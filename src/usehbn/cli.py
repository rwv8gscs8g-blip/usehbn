"""CLI entry point for the HBN protocol scaffold.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional

from usehbn import __version__
from usehbn.execution.engine import execute_request
from usehbn.protocol.consent import CONSENT_QUESTION
from usehbn.protocol.readback import (
    HEARBACK_STATUSES,
    TRACK_CHOICES,
    create_readback_record,
    update_hearback_status,
)
from usehbn.protocol.result import RISK_FLAG_NAMES, create_result_record
from usehbn.runtime import SUPPORTED_RUNTIMES, inspect_target, install_runtime_adapter
from usehbn.state.store import append_result_state
from usehbn.utils.logger import write_json
from usehbn.utils.time import utc_now_iso

RESULT_OUTCOMES = [
    "executed",
    "executed_with_risk",
    "blocked_by_guardian",
    "rejected",
    "failed",
]
HUMAN_STATUSES = [
    "approved",
    "rejected",
    "conditional",
    "not_reviewed",
]


def _program_name() -> str:
    return Path(sys.argv[0]).name or "usehbn"


def _add_protocol_arguments(parser: argparse.ArgumentParser, *, sentence_required: bool) -> None:
    parser.add_argument(
        "sentence",
        nargs=None if sentence_required else "?",
        help='Text to evaluate, for example: "use hbn analyze this system"',
    )
    parser.add_argument(
        "--request-consent",
        action="store_true",
        help="Ask the Contribution Consent Protocol question interactively after activation.",
    )
    parser.add_argument(
        "--consent",
        choices=["yes", "no"],
        help="Resolve consent non-interactively. Useful for scripts and tests.",
    )
    parser.add_argument(
        "--scope",
        default="language_advancement",
        help="Consent scope to record if consent is granted.",
    )
    parser.add_argument(
        "--duration",
        default="session",
        help="Consent duration to record if consent is granted.",
    )
    parser.add_argument(
        "--contribution-units",
        type=int,
        default=1,
        help="Declared contribution units for the consent record.",
    )
    parser.add_argument(
        "--allow-operation",
        action="append",
        default=[],
        help="Allowed operation for a granted consent record. Repeatable.",
    )
    parser.add_argument(
        "--storage-dir",
        help="Optional base directory for local HBN state such as consents and logs.",
    )
    parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog=_program_name(),
        description="Run the initial HBN protocol scaffold against a sentence.",
    )
    _add_protocol_arguments(parser, sentence_required=True)
    return parser


def build_root_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog=_program_name(),
        description="Run the HBN protocol scaffold or manage HBN protocol records.",
    )
    subparsers = parser.add_subparsers(dest="command")

    run_parser = subparsers.add_parser(
        "run",
        help="Run the HBN protocol scaffold against a sentence.",
    )
    _add_protocol_arguments(run_parser, sentence_required=True)

    init_parser = subparsers.add_parser(
        "init",
        help="Initialize HBN protocol state in a target directory.",
    )
    init_parser.add_argument(
        "--target",
        default=".",
        help="Target directory to initialize. Defaults to the current directory.",
    )
    init_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    version_parser = subparsers.add_parser(
        "version",
        help="Print the HBN protocol version.",
    )
    version_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    inspect_parser = subparsers.add_parser(
        "inspect",
        help="Inspect HBN state and runtime adapters in a target directory.",
    )
    inspect_parser.add_argument(
        "--target",
        default=".",
        help="Target directory to inspect. Defaults to the current directory.",
    )
    inspect_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    install_parser = subparsers.add_parser(
        "install",
        help="Install a runtime adapter into a target directory.",
    )
    install_parser.add_argument(
        "--runtime",
        required=True,
        choices=SUPPORTED_RUNTIMES,
        help="Runtime adapter to install.",
    )
    install_parser.add_argument(
        "--target",
        default=".",
        help="Target directory where the adapter will be written.",
    )
    install_parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite an existing adapter file.",
    )
    install_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    readback_parser = subparsers.add_parser(
        "readback",
        help="Create a semantic readback record.",
    )
    readback_parser.add_argument("exec_id", help="Execution identifier for the readback.")
    readback_parser.add_argument("--agent-id", required=True, help="Agent identifier for traceability.")
    readback_parser.add_argument("--intent-json", required=True, help="Structured intent JSON.")
    readback_parser.add_argument(
        "--guardian-json",
        default='{"status":"clear","warnings":[]}',
        help="Guardian result JSON.",
    )
    readback_parser.add_argument(
        "--track",
        default="computed",
        choices=TRACK_CHOICES,
        help="Track classification. Defaults to computed.",
    )
    readback_parser.add_argument(
        "--hearback-status",
        default="pending",
        choices=HEARBACK_STATUSES,
        help="Initial hearback status.",
    )
    readback_parser.add_argument(
        "--understanding",
        required=True,
        help="Executor understanding of the requested work.",
    )
    readback_parser.add_argument(
        "--invariant",
        action="append",
        required=True,
        help="Invariant that must be preserved. Repeatable.",
    )
    readback_parser.add_argument(
        "--plan-step",
        action="append",
        required=True,
        help="Concrete planned action. Repeatable.",
    )
    readback_parser.add_argument(
        "--out-of-scope",
        action="append",
        default=[],
        help="Explicit out-of-scope item. Repeatable.",
    )
    readback_parser.add_argument(
        "--residual-risk",
        action="append",
        default=[],
        help="Residual risk acknowledged before execution. Repeatable.",
    )
    readback_parser.add_argument(
        "--storage-dir",
        help="Optional base directory for local HBN state such as readbacks and results.",
    )
    readback_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    hearback_parser = subparsers.add_parser(
        "hearback",
        help="Update the hearback status for an existing readback.",
    )
    hearback_parser.add_argument("exec_id", help="Execution identifier for the readback.")
    hearback_parser.add_argument(
        "--status",
        required=True,
        choices=HEARBACK_STATUSES,
        help="New hearback status.",
    )
    hearback_parser.add_argument(
        "--storage-dir",
        help="Optional base directory for local HBN state such as readbacks and results.",
    )
    hearback_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    result_parser = subparsers.add_parser(
        "result",
        help="Create an Execution Result Protocol record.",
    )
    result_parser.add_argument("exec_id", help="Execution identifier associated with the ERP record.")
    result_parser.add_argument("--agent-id", required=True, help="Agent identifier for traceability.")
    result_parser.add_argument("--action", required=True, help="Action taken for this result record.")
    result_parser.add_argument(
        "--outcome",
        required=True,
        choices=RESULT_OUTCOMES,
        help="ERP outcome classification.",
    )
    result_parser.add_argument(
        "--human-status",
        required=True,
        choices=HUMAN_STATUSES,
        help="Human review status for this result record.",
    )
    result_parser.add_argument(
        "--readback-id",
        help="Linked readback identifier when required by the protocol.",
    )
    result_parser.add_argument(
        "--risk-flags",
        default="",
        help="Comma-separated risk flags to set true.",
    )
    result_parser.add_argument("--notes", help="Optional human review notes.")
    result_parser.add_argument(
        "--evidence",
        action="append",
        default=[],
        help="Evidence entry in the form type:reference. Repeatable.",
    )
    result_parser.add_argument(
        "--storage-dir",
        help="Optional base directory for local HBN state such as results and state.",
    )
    result_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )
    return parser


def _prompt_for_consent() -> bool:
    answer = input(f"{CONSENT_QUESTION} [yes/no]: ").strip().lower()
    return answer in {"y", "yes"}


def _parse_json_argument(raw_value: str, argument_name: str) -> Dict[str, Any]:
    try:
        parsed = json.loads(raw_value)
    except json.JSONDecodeError as exc:
        raise ValueError(f"Invalid JSON for {argument_name}: {exc.msg}") from exc
    if not isinstance(parsed, dict):
        raise ValueError(f"{argument_name} must decode to a JSON object")
    return parsed


def run_protocol(args: argparse.Namespace) -> Dict[str, Any]:
    grant_consent: Optional[bool] = None

    if args.consent == "yes":
        grant_consent = True
    elif args.consent == "no":
        grant_consent = False
    elif args.request_consent:
        grant_consent = _prompt_for_consent()

    return execute_request(
        args.sentence,
        storage_dir=Path(args.storage_dir).expanduser() if args.storage_dir else None,
        consent_resolution=grant_consent,
        consent_scope=args.scope,
        consent_duration=args.duration,
        contribution_units=args.contribution_units,
        allowed_operations=args.allow_operation or ["local_storage"],
    )


def _hbn_dir(target: Path) -> Path:
    return target / ".hbn"


def _detect_system_type(target: Path) -> str:
    has_git = (target / ".git").exists()
    has_python = (target / "pyproject.toml").exists() or (target / "setup.py").exists()
    has_node = (target / "package.json").exists()
    if has_python and has_node:
        return "mixed_python_node"
    if has_python:
        return "python"
    if has_node:
        return "node"
    if has_git:
        return "git"
    return "generic"


def run_init(args: argparse.Namespace) -> Dict[str, Any]:
    target = Path(args.target).expanduser().resolve()
    hbn_dir = _hbn_dir(target)
    if hbn_dir.exists():
        return {
            "status": "already_initialized",
            "path": str(hbn_dir),
        }

    relay_dir = hbn_dir / "relay"
    knowledge_dir = hbn_dir / "knowledge"
    for directory in (
        hbn_dir / "readbacks",
        hbn_dir / "results",
        relay_dir,
        hbn_dir / "relay-archive",
        knowledge_dir,
    ):
        directory.mkdir(parents=True, exist_ok=True)

    manifest = {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "initialized_at": utc_now_iso(),
        "target_path": str(target),
        "system_type": _detect_system_type(target),
    }
    state = {
        "executions": [],
        "decisions": [],
        "context_history": [],
        "results": [],
        "readbacks": [],
    }
    write_json(hbn_dir / "manifest.json", manifest)
    write_json(hbn_dir / "state.json", state)

    relay_index = (
        "# HBN Relay — Estado Atual\n\n"
        "**Bastao atual:** humano\n"
        f"**Ultima atualizacao:** {utc_now_iso()}\n\n"
        "## Iteracoes Ativas\n\n"
        "Nenhuma.\n\n"
        "## Proxima Acao\n\n"
        "Iniciar a primeira iteracao protocolada.\n"
    )
    (relay_dir / "INDEX.md").write_text(relay_index, encoding="utf-8")
    (knowledge_dir / "INDEX.md").write_text("# HBN Knowledge Base\n\nNenhuma entrada ainda.\n", encoding="utf-8")

    return {
        "status": "initialized",
        "path": str(hbn_dir),
        "manifest": manifest,
    }


def run_version(_: argparse.Namespace) -> Dict[str, Any]:
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "cli": "hbn",
    }


def run_inspect(args: argparse.Namespace) -> Dict[str, Any]:
    inspection = inspect_target(Path(args.target))
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "inspection": inspection,
    }


def run_install(args: argparse.Namespace) -> Dict[str, Any]:
    result = install_runtime_adapter(
        args.runtime,
        Path(args.target),
        force=args.force,
    )
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "adapter_installation": result,
    }


def _parse_risk_flags(risk_flags: str) -> Dict[str, bool]:
    selected_flags: Dict[str, bool] = {}
    if not risk_flags.strip():
        return selected_flags

    for raw_flag in risk_flags.split(","):
        flag = raw_flag.strip()
        if not flag:
            continue
        if flag not in RISK_FLAG_NAMES:
            raise ValueError(f"Unknown risk flag: {flag}")
        selected_flags[flag] = True
    return selected_flags


def _parse_evidence(entries: List[str]) -> List[Dict[str, str]]:
    evidence: List[Dict[str, str]] = []
    for entry in entries:
        if ":" not in entry:
            raise ValueError(f"Evidence must use type:reference format: {entry}")
        evidence_type, reference = entry.split(":", 1)
        evidence_type = evidence_type.strip()
        reference = reference.strip()
        if not evidence_type:
            raise ValueError(f"Evidence type must be non-empty: {entry}")
        if not reference:
            raise ValueError(f"Evidence reference must be non-empty: {entry}")
        evidence.append({"type": evidence_type, "reference": reference})
    return evidence


def run_readback_protocol(args: argparse.Namespace) -> Dict[str, Any]:
    storage_dir = Path(args.storage_dir).expanduser() if args.storage_dir else None
    record = create_readback_record(
        execution_id=args.exec_id,
        agent_id=args.agent_id,
        intent=_parse_json_argument(args.intent_json, "--intent-json"),
        guardian_result=_parse_json_argument(args.guardian_json, "--guardian-json"),
        understanding=args.understanding.strip(),
        invariants_preserved=[item.strip() for item in args.invariant],
        action_plan=[item.strip() for item in args.plan_step],
        out_of_scope=[item.strip() for item in args.out_of_scope if item.strip()],
        residual_risks=[item.strip() for item in args.residual_risk if item.strip()],
        track=args.track,
        hearback_status=args.hearback_status,
        storage_dir=storage_dir,
    )
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "readback_record": record,
    }


def run_hearback_protocol(args: argparse.Namespace) -> Dict[str, Any]:
    storage_dir = Path(args.storage_dir).expanduser() if args.storage_dir else None
    record = update_hearback_status(
        execution_id=args.exec_id,
        hearback_status=args.status,
        storage_dir=storage_dir,
    )
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "readback_record": record,
    }


def run_result_protocol(args: argparse.Namespace) -> Dict[str, Any]:
    storage_dir = Path(args.storage_dir).expanduser() if args.storage_dir else None
    result_record = create_result_record(
        execution_id=args.exec_id,
        agent_id=args.agent_id,
        hbn_outcome=args.outcome,
        human_status=args.human_status,
        action_taken=args.action,
        risk_flags=_parse_risk_flags(args.risk_flags),
        review_notes=args.notes,
        evidence=_parse_evidence(args.evidence),
        readback_id=args.readback_id,
        storage_dir=storage_dir,
    )
    state_path = append_result_state(result_record, base_dir=storage_dir)
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "erp_record": result_record,
        "state_path": str(state_path),
    }


def main() -> int:
    subcommands = {"run", "init", "version", "inspect", "install", "result", "readback", "hearback"}
    if len(sys.argv) > 1 and sys.argv[1] in subcommands:
        parser = build_root_parser()
        args = parser.parse_args()
        if args.command == "run":
            result = run_protocol(args)
        elif args.command == "init":
            result = run_init(args)
        elif args.command == "version":
            result = run_version(args)
        elif args.command == "inspect":
            result = run_inspect(args)
        elif args.command == "install":
            result = run_install(args)
        elif args.command == "readback":
            result = run_readback_protocol(args)
        elif args.command == "hearback":
            result = run_hearback_protocol(args)
        else:
            result = run_result_protocol(args)
        indent = args.indent
    else:
        parser = build_parser()
        args = parser.parse_args()
        result = run_protocol(args)
        indent = args.indent

    print(json.dumps(result, indent=indent, ensure_ascii=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

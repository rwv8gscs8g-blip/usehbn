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
from usehbn.runtime import (
    SUPPORTED_RUNTIMES,
    detect_runtime_from_env,
    inspect_target,
    install_runtime_adapter,
    refresh_all_adapters,
)
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
ATTENTION_MODES = ("sound", "flash", "silent")
ATTENTION_EVENTS = ("security_blocked_suggestion", "human_decision")
ATTENTION_CHOICES = {
    "a": "silent",
    "b": "flash",
}


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
        "--runtime",
        choices=list(SUPPORTED_RUNTIMES) + ["auto"],
        help="Runtime adapter to install during init. Use 'auto' for environment detection.",
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

    attention_parser = subparsers.add_parser(
        "attention",
        help="Configure local HBN human-attention behavior for this target.",
    )
    attention_parser.add_argument(
        "--target",
        default=".",
        help="Target directory whose .hbn attention preferences will be updated.",
    )
    attention_parser.add_argument(
        "--mode",
        choices=ATTENTION_MODES,
        help="Attention mode for HBN escalation moments.",
    )
    attention_parser.add_argument(
        "--choice",
        choices=tuple(ATTENTION_CHOICES.keys()),
        help="Shortcut choice: A silences sound, B switches to flash.",
    )
    attention_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    notify_parser = subparsers.add_parser(
        "notify",
        help="Emit a local HBN human-attention notification for a blocked or decision-needed cycle.",
    )
    notify_parser.add_argument(
        "--target",
        default=".",
        help="Target directory whose .hbn attention preferences will be used.",
    )
    notify_parser.add_argument(
        "--event",
        required=True,
        choices=ATTENTION_EVENTS,
        help="Protocol event that requires human attention.",
    )
    notify_parser.add_argument(
        "--message",
        default="",
        help="Optional additional message to print with the notification.",
    )
    notify_parser.add_argument(
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
    hearback_parser.add_argument("exec_id", nargs="?", default=None, help="Execution identifier for the readback.")
    hearback_parser.add_argument(
        "--status",
        required=True,
        choices=HEARBACK_STATUSES,
        help="New hearback status.",
    )
    hearback_parser.add_argument(
        "--last",
        action="store_true",
        help="Operate on the most recent pending readback instead of specifying exec_id.",
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
        "--env-key",
        action="append",
        default=[],
        help="Environment key=value pair for the result record. Repeatable.",
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

    refresh_parser = subparsers.add_parser(
        "refresh",
        help="Refresh all installed runtime adapters in a target directory.",
    )
    refresh_parser.add_argument(
        "--target",
        default=".",
        help="Target directory whose adapters will be refreshed.",
    )
    refresh_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    relay_parser = subparsers.add_parser(
        "relay",
        help="Inspect or manage the HBN relay coordination layer.",
    )
    relay_sub = relay_parser.add_subparsers(dest="relay_command")

    relay_status_parser = relay_sub.add_parser(
        "status",
        help="Show current relay baton owner and active iterations.",
    )
    relay_status_parser.add_argument(
        "--target",
        default=".",
        help="Target directory to inspect.",
    )
    relay_status_parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level for CLI output.",
    )

    handoff_parser = subparsers.add_parser(
        "handoff",
        help="Transfer the relay baton to another agent with validation.",
    )
    handoff_parser.add_argument(
        "--to",
        required=True,
        dest="handoff_to",
        help="Agent identifier receiving the baton.",
    )
    handoff_parser.add_argument(
        "--summary",
        required=True,
        help="Summary of what was accomplished before handoff.",
    )
    handoff_parser.add_argument(
        "--target",
        default=".",
        help="Target directory with .hbn/ to update.",
    )
    handoff_parser.add_argument(
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


def _relay_index(now_iso: str) -> str:
    return (
        "# HBN Relay — Estado Atual\n\n"
        "**Bastao atual:** humano\n"
        f"**Ultima atualizacao:** {now_iso}\n\n"
        "## Leitura Obrigatoria Para Novas IAs\n\n"
        "- Use uma marcacao visivel de status no inicio do ciclo: `✅ HBN ACTIVE`, `❌ HBN SECURITY BLOCKED SUGGESTION` ou "
        "`🟡 HBN NEEDS HUMAN DECISION`.\n"
        "- Use titulos curtos e visiveis: `🧠 Entendimento e Escopo`, `🧭 Caminho Oficial`, `🛠️ Ação Executada`, "
        "`👨‍💻 Resultado DEV`, `🚦 Aprovação ou Bloqueio`, `➡️ Próximo Passo` e `📝 Documentado em`.\n"
        "- Em bloqueios ou decisoes humanas, use `hbn notify` quando houver execucao local disponivel.\n"
        "- Antes de alterar codigo, registre entendimento resumido, escopo lido e proxima acao.\n"
        "- Arquivos ativos de coordenacao usam o padrao `0001-Assunto.md` em ordem sequencial.\n"
        "- Quando um ciclo for resolvido, mova o arquivo ativo correspondente para `.hbn/relay-archive/`.\n"
        "- Mantenha em `.hbn/relay/` somente o que ainda importa para a continuidade imediata.\n\n"
        "## Iteracoes Ativas\n\n"
        "Nenhuma.\n\n"
        "## Proxima Acao\n\n"
        "Iniciar a primeira iteracao protocolada.\n"
    )


def _knowledge_index() -> str:
    return (
        "# HBN Knowledge Base\n\n"
        "Use esta pasta para descobertas reutilizaveis entre IAs.\n\n"
        "## Convencoes\n\n"
        "- Nomeie arquivos como `0001-Assunto.md`, `0002-Assunto.md` e assim por diante.\n"
        "- Registre apenas o que reduz retrabalho futuro: regras, riscos, padroes, limitacoes e atalhos seguros.\n"
        "- Nao repita historico operacional; isso pertence ao relay ou aos reports.\n\n"
        "Nenhuma entrada ainda.\n"
    )


def _reports_index() -> str:
    return (
        "# HBN Reports\n\n"
        "Use esta pasta para documentos de saida legiveis por humanos e por futuras IAs.\n\n"
        "## Convencoes\n\n"
        "- Nomeie arquivos como `0001-Assunto.md`, `0002-Assunto.md` e assim por diante.\n"
        "- Cada report deve resumir: objetivo, acoes executadas, validacoes, bloqueios e proxima acao.\n"
        "- Prefira reports curtos e orientados a decisao.\n\n"
        "Nenhuma entrada ainda.\n"
    )


def _hbn_readme() -> str:
    return (
        "# HBN Local Runtime Tree\n\n"
        "Esta pasta contem a memoria local do HBN para este projeto.\n\n"
        "- `manifest.json`: identidade do protocolo e do alvo.\n"
        "- `state.json`: estado estrutural local.\n"
        "- `relay/`: coordenacao ativa entre humano e IAs.\n"
        "- `relay-archive/`: iteracoes resolvidas ou encerradas.\n"
        "- `knowledge/`: descobertas reutilizaveis.\n"
        "- `reports/`: saidas resumidas e legiveis por humanos.\n"
        "- `attention.json`: preferencia local de atencao humana para bloqueios e decisoes.\n"
        "- `readbacks/`: registros formais de readback.\n"
        "- `results/`: registros ERP.\n"
    )


def _append_once(path: Path, marker: str, content: str) -> None:
    if not path.exists():
        path.write_text(content, encoding="utf-8")
        return
    existing = path.read_text(encoding="utf-8")
    if marker in existing:
        return
    separator = "\n" if existing.endswith("\n") else "\n\n"
    path.write_text(f"{existing}{separator}{content}", encoding="utf-8")


def _ensure_hbn_guidance_files(hbn_dir: Path) -> None:
    relay_dir = hbn_dir / "relay"
    knowledge_dir = hbn_dir / "knowledge"
    reports_dir = hbn_dir / "reports"
    reports_dir.mkdir(parents=True, exist_ok=True)
    attention_path = hbn_dir / "attention.json"

    readme_path = hbn_dir / "README.md"
    if not readme_path.exists():
        readme_path.write_text(_hbn_readme(), encoding="utf-8")

    relay_index_path = relay_dir / "INDEX.md"
    if relay_index_path.exists():
        _append_once(
            relay_index_path,
            "## Leitura Obrigatoria Para Novas IAs",
            (
                "## Leitura Obrigatoria Para Novas IAs\n\n"
                "- Use uma marcacao visivel de status no inicio do ciclo: `✅ HBN ACTIVE`, "
                "`❌ HBN SECURITY BLOCKED SUGGESTION` ou `🟡 HBN NEEDS HUMAN DECISION`.\n"
                "- Em bloqueios ou decisoes humanas, use `hbn notify` quando houver execucao local disponivel.\n"
                "- Arquivos ativos de coordenacao usam o padrao `0001-Assunto.md`.\n"
                "- Arquivos resolvidos saem de `.hbn/relay/` e vao para `.hbn/relay-archive/`.\n"
                "- Mantenha em `.hbn/relay/` apenas o contexto operacional realmente ativo.\n"
            ),
        )

    knowledge_index_path = knowledge_dir / "INDEX.md"
    if knowledge_index_path.exists():
        _append_once(
            knowledge_index_path,
            "## Convencoes",
            (
                "## Convencoes\n\n"
                "- Nomeie arquivos como `0001-Assunto.md`, `0002-Assunto.md` e assim por diante.\n"
                "- Registre apenas descobertas reutilizaveis entre IAs.\n"
                "- Nao use a knowledge base para historico operacional de curto prazo.\n"
            ),
        )
    else:
        knowledge_index_path.write_text(_knowledge_index(), encoding="utf-8")

    reports_index_path = reports_dir / "INDEX.md"
    if not reports_index_path.exists():
        reports_index_path.write_text(_reports_index(), encoding="utf-8")

    if not attention_path.exists():
        write_json(attention_path, _default_attention_preferences())


def _default_attention_preferences() -> Dict[str, Any]:
    return {
        "mode": "sound",
        "sound_name": "leak",
        "enabled_for": list(ATTENTION_EVENTS),
        "choices": {
            "a": "silent",
            "b": "flash",
        },
    }


def _attention_preferences_path(target: Path) -> Path:
    return _hbn_dir(target) / "attention.json"


def _load_attention_preferences(target: Path) -> Dict[str, Any]:
    prefs_path = _attention_preferences_path(target)
    if prefs_path.exists():
        return json.loads(prefs_path.read_text(encoding="utf-8"))
    return _default_attention_preferences()


def _emit_attention(mode: str) -> None:
    if mode == "sound":
        sys.stdout.write("\a\a")
        sys.stdout.flush()
    elif mode == "flash":
        sys.stdout.write("\033[?5h\033[?5l")
        sys.stdout.flush()


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
    reports_dir = hbn_dir / "reports"
    for directory in (
        hbn_dir / "readbacks",
        hbn_dir / "results",
        relay_dir,
        hbn_dir / "relay-archive",
        knowledge_dir,
        reports_dir,
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
    write_json(hbn_dir / "attention.json", _default_attention_preferences())
    now_iso = utc_now_iso()
    (hbn_dir / "README.md").write_text(_hbn_readme(), encoding="utf-8")
    (relay_dir / "INDEX.md").write_text(_relay_index(now_iso), encoding="utf-8")
    (knowledge_dir / "INDEX.md").write_text(_knowledge_index(), encoding="utf-8")
    (reports_dir / "INDEX.md").write_text(_reports_index(), encoding="utf-8")
    # Suggest .gitignore entries for ephemeral protocol artifacts
    gitignore_suggestions: List[str] = []
    gitignore_path = target / ".gitignore"
    if gitignore_path.exists():
        gitignore_content = gitignore_path.read_text(encoding="utf-8")
        for entry in (".hbn/readbacks/", ".hbn/results/"):
            if entry not in gitignore_content:
                gitignore_suggestions.append(entry)

    # Auto-detect or use specified runtime for adapter installation
    adapter_result = None
    requested_runtime = getattr(args, "runtime", None)
    if requested_runtime:
        runtime_to_install = requested_runtime
        if runtime_to_install == "auto":
            runtime_to_install = detect_runtime_from_env(target)
        if runtime_to_install and runtime_to_install in SUPPORTED_RUNTIMES:
            adapter_result = install_runtime_adapter(runtime_to_install, target, force=False)

    result: Dict[str, Any] = {
        "status": "initialized",
        "path": str(hbn_dir),
        "manifest": manifest,
    }
    if adapter_result:
        result["adapter_installed"] = adapter_result
    if gitignore_suggestions:
        result["gitignore_suggestions"] = gitignore_suggestions
    return result


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
    target = Path(args.target).expanduser().resolve()
    hbn_dir = _hbn_dir(target)
    if hbn_dir.exists():
        _ensure_hbn_guidance_files(hbn_dir)
    result = install_runtime_adapter(
        args.runtime,
        target,
        force=args.force,
    )
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "adapter_installation": result,
    }


def run_attention(args: argparse.Namespace) -> Dict[str, Any]:
    target = Path(args.target).expanduser().resolve()
    hbn_dir = _hbn_dir(target)
    hbn_dir.mkdir(parents=True, exist_ok=True)
    prefs = _load_attention_preferences(target)
    selected_mode = args.mode
    if args.choice:
        selected_mode = ATTENTION_CHOICES[args.choice.lower()]
    if not selected_mode:
        raise ValueError("Either --mode or --choice is required")
    prefs["mode"] = selected_mode
    write_json(_attention_preferences_path(target), prefs)
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "attention_preferences": prefs,
        "human_prompt": (
            "Digite A para retirar o aviso sonoro ou digite B para apenas piscar a tela quando terminar."
        ),
    }


def run_notify(args: argparse.Namespace) -> Dict[str, Any]:
    target = Path(args.target).expanduser().resolve()
    prefs = _load_attention_preferences(target)
    mode = prefs.get("mode", "sound")
    event = args.event
    if event in prefs.get("enabled_for", []):
        _emit_attention(mode)
    event_label = (
        "❌ HBN SECURITY BLOCKED SUGGESTION"
        if event == "security_blocked_suggestion"
        else "🟡 HBN NEEDS HUMAN DECISION"
    )
    guidance = (
        "Para sua segurança e conformidade, a ação da IA foi bloqueada provisoriamente pelo Human Brain Net ao aplicar "
        "pensamento humano associado ao contexto.\n"
        "O ciclo não deve prosseguir sem passar por análise humana.\n"
        "Isso evita promoção por caminho inseguro, interpretação incompleta ou execução fora das regras do projeto."
        if event == "security_blocked_suggestion"
        else "O Human Brain Net solicita análise humana antes da próxima ação automática."
    )
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "notification": {
            "event": event,
            "label": event_label,
            "mode": mode,
            "sound_name": prefs.get("sound_name", "leak"),
            "message": args.message,
            "guidance": guidance,
            "human_prompt": (
                "Digite A para retirar o aviso sonoro ou digite B para apenas piscar a tela quando terminar."
            ),
            "choice_commands": {
                "A": "hbn attention --mode silent",
                "B": "hbn attention --mode flash",
            },
        },
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


def _find_latest_pending_readback(storage_dir: Optional[Path] = None) -> Optional[str]:
    """Find the most recent readback file with pending hearback status."""
    from usehbn.utils.config import default_state_dir

    base = default_state_dir(storage_dir)
    readbacks_dir = base / "readbacks"
    if not readbacks_dir.exists():
        return None
    candidates = []
    for path in sorted(readbacks_dir.glob("*.json"), reverse=True):
        record = json.loads(path.read_text(encoding="utf-8"))
        if record.get("hearback_status") == "pending":
            candidates.append((record.get("created_at", ""), record["execution_id"]))
    if not candidates:
        return None
    candidates.sort(key=lambda x: x[0], reverse=True)
    return candidates[0][1]


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
    exec_id = args.exec_id
    if getattr(args, "last", False) and not exec_id:
        exec_id = _find_latest_pending_readback(storage_dir)
        if exec_id is None:
            return {
                "project": "HBN — Human Brain Net",
                "protocol_version": __version__,
                "error": "No pending readback found.",
            }
    if not exec_id:
        return {
            "project": "HBN — Human Brain Net",
            "protocol_version": __version__,
            "error": "exec_id is required. Use --last to operate on the most recent pending readback.",
        }
    record = update_hearback_status(
        execution_id=exec_id,
        hearback_status=args.status,
        storage_dir=storage_dir,
    )
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "readback_record": record,
    }


def _parse_env_keys(entries: List[str]) -> Dict[str, str]:
    env: Dict[str, str] = {}
    for entry in entries:
        if "=" not in entry:
            raise ValueError(f"Environment key must use key=value format: {entry}")
        key, value = entry.split("=", 1)
        env[key.strip()] = value.strip()
    return env


def run_result_protocol(args: argparse.Namespace) -> Dict[str, Any]:
    storage_dir = Path(args.storage_dir).expanduser() if args.storage_dir else None
    environment = _parse_env_keys(getattr(args, "env_key", []))
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
        environment=environment if environment else None,
        storage_dir=storage_dir,
    )
    state_path = append_result_state(result_record, base_dir=storage_dir)
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "erp_record": result_record,
        "state_path": str(state_path),
    }


def run_refresh(args: argparse.Namespace) -> Dict[str, Any]:
    target = Path(args.target).expanduser().resolve()
    results = refresh_all_adapters(target)
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "refreshed_adapters": results,
        "target": str(target),
    }


def _load_relay_state(target: Path) -> Dict[str, Any]:
    hbn_dir = _hbn_dir(target)
    state_path = hbn_dir / "relay" / "state.json"
    if state_path.exists():
        return json.loads(state_path.read_text(encoding="utf-8"))
    # Infer basic state from filesystem if state.json does not exist
    relay_dir = hbn_dir / "relay"
    active: List[str] = []
    if relay_dir.exists():
        active = sorted(
            p.name for p in relay_dir.glob("*.md")
            if p.name != "INDEX.md"
        )
    return {
        "baton_owner": "unknown",
        "baton_since": None,
        "active_iterations": active,
        "pending_decisions": 0,
        "last_handoff": None,
    }


def _save_relay_state(target: Path, state: Dict[str, Any]) -> Path:
    hbn_dir = _hbn_dir(target)
    state_path = hbn_dir / "relay" / "state.json"
    write_json(state_path, state)
    return state_path


def run_relay_status(args: argparse.Namespace) -> Dict[str, Any]:
    target = Path(args.target).expanduser().resolve()
    state = _load_relay_state(target)
    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "relay_status": state,
        "target": str(target),
    }


def _find_pending_readbacks(target: Path) -> List[str]:
    hbn_dir = _hbn_dir(target)
    readbacks_dir = hbn_dir / "readbacks"
    pending: List[str] = []
    if readbacks_dir.exists():
        for path in sorted(readbacks_dir.glob("*.json")):
            record = json.loads(path.read_text(encoding="utf-8"))
            if record.get("hearback_status") == "pending":
                pending.append(record["execution_id"])
    return pending


def run_handoff(args: argparse.Namespace) -> Dict[str, Any]:
    target = Path(args.target).expanduser().resolve()
    hbn_dir = _hbn_dir(target)
    if not hbn_dir.exists():
        return {
            "project": "HBN — Human Brain Net",
            "protocol_version": __version__,
            "error": ".hbn/ does not exist. Run hbn init first.",
        }

    # Validate: no pending hearbacks
    pending = _find_pending_readbacks(target)
    if pending:
        return {
            "project": "HBN — Human Brain Net",
            "protocol_version": __version__,
            "error": "Cannot handoff: pending readbacks require hearback confirmation.",
            "pending_readbacks": pending,
        }

    relay_dir = hbn_dir / "relay"
    archive_dir = hbn_dir / "relay-archive"
    archive_dir.mkdir(parents=True, exist_ok=True)

    # Archive resolved relay files (non-INDEX markdown files)
    archived: List[str] = []
    if relay_dir.exists():
        now_prefix = utc_now_iso().replace(":", "").replace("-", "")[:15]
        for path in sorted(relay_dir.glob("*.md")):
            if path.name == "INDEX.md":
                continue
            dest = archive_dir / f"{now_prefix}-{path.name}"
            path.rename(dest)
            archived.append(path.name)

    # Update relay state
    now_iso = utc_now_iso()
    current_state = _load_relay_state(target)
    previous_owner = current_state.get("baton_owner", "unknown")
    new_state = {
        "baton_owner": args.handoff_to,
        "baton_since": now_iso,
        "active_iterations": [],
        "pending_decisions": 0,
        "last_handoff": {
            "from": previous_owner,
            "to": args.handoff_to,
            "at": now_iso,
            "summary": args.summary,
        },
    }
    _save_relay_state(target, new_state)

    # Update INDEX.md
    index_path = relay_dir / "INDEX.md"
    if index_path.exists():
        index_content = index_path.read_text(encoding="utf-8")
        lines = index_content.split("\n")
        updated_lines = []
        for line in lines:
            if line.startswith("**Bastao atual:"):
                updated_lines.append(f"**Bastao atual:** {args.handoff_to}")
            elif line.startswith("**Ultima atualizacao:"):
                updated_lines.append(f"**Ultima atualizacao:** {now_iso}")
            else:
                updated_lines.append(line)
        index_path.write_text("\n".join(updated_lines), encoding="utf-8")

    return {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "handoff": {
            "from": previous_owner,
            "to": args.handoff_to,
            "summary": args.summary,
            "archived_files": archived,
            "timestamp": now_iso,
        },
    }


def main() -> int:
    subcommands = {
        "run",
        "init",
        "version",
        "inspect",
        "install",
        "attention",
        "notify",
        "result",
        "readback",
        "hearback",
        "refresh",
        "relay",
        "handoff",
    }
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
        elif args.command == "attention":
            result = run_attention(args)
        elif args.command == "notify":
            result = run_notify(args)
        elif args.command == "readback":
            result = run_readback_protocol(args)
        elif args.command == "hearback":
            result = run_hearback_protocol(args)
        elif args.command == "refresh":
            result = run_refresh(args)
        elif args.command == "relay":
            if getattr(args, "relay_command", None) == "status":
                result = run_relay_status(args)
            else:
                result = {"error": "Unknown relay subcommand. Use: hbn relay status"}
        elif args.command == "handoff":
            result = run_handoff(args)
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

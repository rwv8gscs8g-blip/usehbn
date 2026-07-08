"""Golden CLI characterization tests for the public command surface."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any, Callable, Dict, List, Tuple

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.cli import main


PROJECT = "HBN — Human Brain Net"
PROTOCOL_VERSION = "0.3.0"

ISO_RE = re.compile(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|\+00:00)?")
EXEC_RE = re.compile(r"exec-\d{8}T\d{6}Z-[0-9a-f]{8}")
CONNECTOR_APPROVAL_RE = re.compile(r"connector-approval-[0-9a-f]+")
REMOTE_LOOKUP_RE = re.compile(r"remote-lookup-[0-9a-f]+")


def _run_cli(monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], argv: List[str], cwd: Path) -> Tuple[int, str]:
    monkeypatch.setattr(sys, "argv", ["hbn", *argv])
    monkeypatch.chdir(cwd)
    code = main()
    captured = capsys.readouterr()
    assert captured.err == ""
    return code, captured.out


def _normalize(value: Any, tmp_path: Path) -> Any:
    if isinstance(value, dict):
        return {key: _normalize(item, tmp_path) for key, item in value.items()}
    if isinstance(value, list):
        return [_normalize(item, tmp_path) for item in value]
    if isinstance(value, str):
        normalized = value
        tmp_variants = {
            str(tmp_path),
            str(tmp_path.resolve()),
            f"/private{tmp_path}",
            f"/private{tmp_path.resolve()}",
        }
        for tmp_variant in sorted(tmp_variants, key=len, reverse=True):
            normalized = normalized.replace(tmp_variant, "<TMP>")
        normalized = EXEC_RE.sub("<EXEC_ID>", normalized)
        normalized = ISO_RE.sub("<ISO8601>", normalized)
        normalized = CONNECTOR_APPROVAL_RE.sub("<CONNECTOR_APPROVAL_ID>", normalized)
        normalized = REMOTE_LOOKUP_RE.sub("<REMOTE_LOOKUP_ID>", normalized)
        return normalized
    return value


def _json_output(raw: str, tmp_path: Path) -> Dict[str, Any]:
    return _normalize(json.loads(raw), tmp_path)


def _envelope(payload: Dict[str, Any]) -> Dict[str, str]:
    return {
        "project": payload["project"],
        "protocol_version": payload["protocol_version"],
    }


def _setup_init(monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], tmp_path: Path, target_name: str) -> Path:
    target = tmp_path / target_name
    code, _ = _run_cli(monkeypatch, capsys, ["init", "--target", str(target)], tmp_path)
    assert code == 0
    return target


def _case_run(tmp_path: Path) -> List[str]:
    return ["run", "hello", "--storage-dir", str(tmp_path / "run-storage")]


def _summary_run(payload: Dict[str, Any]) -> Dict[str, Any]:
    return {
        **_envelope(payload),
        "hbn_activated": payload["hbn_activated"],
        "stage": payload["stage"],
        "activation": payload["activation"],
        "validation": payload["validation"],
        "consent_status": payload["contribution_consent_protocol"]["status"],
        "execution": payload["execution"],
    }


def _case_translate(tmp_path: Path) -> List[str]:
    return ["translate", "use hbn analyze this system", "--target", str(tmp_path / "translate-target")]


def _summary_translate(payload: Dict[str, Any]) -> Dict[str, Any]:
    translation = payload["translation"]
    return {
        **_envelope(payload),
        "status": translation["status"],
        "activation": translation["activation"],
        "recommended_machine_path": translation["recommended_machine_path"],
        "connector_contract_status": translation["connector_contract"]["status"],
        "connector_strategy_status": translation["connector_strategy"]["status"],
        "language_fallback": translation["language_fallback"],
    }


def _case_connector_inspect(tmp_path: Path) -> List[str]:
    return ["connector", "inspect", "--target", str(tmp_path / "connector-inspect")]


def _summary_connector_inspect(payload: Dict[str, Any]) -> Dict[str, Any]:
    plan = payload["connector"]["plan"]
    return {
        **_envelope(payload),
        "target": payload["connector"]["target"],
        "contract_status": plan["connector_contract"]["status"],
        "recommended_choice": plan["connector_contract"]["recommended_choice"],
        "remote_lookup_required": plan["connector_contract"]["privacy_contract"]["remote_lookup"]["required_now"],
        "strategy_status": plan["connector_strategy"]["status"],
        "trust_level": plan["connector_strategy"]["trust_policy"]["trust_level"],
    }


def _case_connector_ensure(tmp_path: Path) -> List[str]:
    return [
        "connector",
        "ensure",
        "--target",
        str(tmp_path / "connector-ensure"),
        "--approve-discovery",
        "--approve-remote-lookup",
    ]


def _summary_connector_ensure(payload: Dict[str, Any]) -> Dict[str, Any]:
    ensure = payload["connector"]["ensure"]
    return {
        **_envelope(payload),
        "target": payload["connector"]["target"],
        "status": ensure["status"],
        "approval": {
            "approved": ensure["approval_record"]["approved"],
            "choice_id": ensure["approval_record"]["choice_id"],
            "requires_remote_lookup": ensure["approval_record"]["requires_remote_lookup"],
        },
        "remote_resolution_status": ensure["remote_resolution"]["status"],
        "request_path": ensure["request_path"],
    }


def _case_init(tmp_path: Path) -> List[str]:
    return ["init", "--target", str(tmp_path / "init-target")]


def _summary_init(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_version(_: Path) -> List[str]:
    return ["version"]


def _summary_version(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_inspect(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> List[str]:
    target = _setup_init(monkeypatch, capsys, tmp_path, "inspect-target")
    return ["inspect", "--target", str(target)]


def _summary_inspect(payload: Dict[str, Any]) -> Dict[str, Any]:
    inspection = payload["inspection"]
    return {
        **_envelope(payload),
        "target_path": inspection["target_path"],
        "initialized": inspection["initialized"],
        "manifest_matches_current_version": inspection["manifest_matches_current_version"],
        "runtime_adapters": inspection["runtime_adapters"],
        "runtime_detection": inspection["runtime_detection"],
        "state_path": inspection["state_path"],
        "state_exists": inspection["state_exists"],
        "packaging": inspection["packaging"],
    }


def _case_doctor(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> List[str]:
    target = _setup_init(monkeypatch, capsys, tmp_path, "doctor-target")
    return ["doctor", "--target", str(target)]


def _summary_doctor(payload: Dict[str, Any]) -> Dict[str, Any]:
    doctor = payload["doctor"]
    return {
        **_envelope(payload),
        "status": doctor["status"],
        "target": doctor["target"],
        "checks": doctor["checks"],
        "warnings": doctor["warnings"],
        "next_steps": doctor["next_steps"],
    }


def _case_quickstart(tmp_path: Path) -> List[str]:
    return ["quickstart", "--target", str(tmp_path / "quickstart-target")]


def _summary_quickstart(payload: Dict[str, Any]) -> Dict[str, Any]:
    quickstart = payload["quickstart"]
    return {
        **_envelope(payload),
        "status": quickstart["status"],
        "target": quickstart["target"],
        "initialized": quickstart["initialized"],
        "init_result": quickstart["init_result"],
        "adapter_installed": quickstart["adapter_installed"],
        "quickstart_note": quickstart["quickstart_note"],
        "next_steps": quickstart["next_steps"],
        "safe_testing_note": quickstart["safe_testing_note"],
    }


def _case_install(tmp_path: Path) -> List[str]:
    return ["install", "--runtime", "codex", "--target", str(tmp_path / "install-target")]


def _summary_install(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_attention(tmp_path: Path) -> List[str]:
    return ["attention", "--target", str(tmp_path / "attention-target"), "--mode", "flash"]


def _summary_attention(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_notify(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> List[str]:
    target = tmp_path / "notify-target"
    code, _ = _run_cli(monkeypatch, capsys, ["attention", "--target", str(target), "--mode", "silent"], tmp_path)
    assert code == 0
    return ["notify", "--target", str(target), "--event", "human_decision", "--message", "decide"]


def _summary_notify(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_readback(tmp_path: Path) -> List[str]:
    return [
        "readback",
        "exec-rb",
        "--agent-id",
        "codex",
        "--intent-json",
        '{"objective":"test","constraints":[],"risks":[]}',
        "--understanding",
        "Understand",
        "--invariant",
        "Keep contract",
        "--plan-step",
        "Test CLI",
        "--storage-dir",
        str(tmp_path / "readback-storage"),
    ]


def _summary_readback(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_hearback(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> List[str]:
    storage = tmp_path / "hearback-storage"
    code, _ = _run_cli(
        monkeypatch,
        capsys,
        [
            "readback",
            "exec-rb",
            "--agent-id",
            "codex",
            "--intent-json",
            '{"objective":"test","constraints":[],"risks":[]}',
            "--understanding",
            "Understand",
            "--invariant",
            "Keep contract",
            "--plan-step",
            "Test CLI",
            "--storage-dir",
            str(storage),
        ],
        tmp_path,
    )
    assert code == 0
    return ["hearback", "exec-rb", "--status", "confirmed", "--storage-dir", str(storage)]


def _summary_hearback(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_result(tmp_path: Path) -> List[str]:
    return [
        "result",
        "exec-result",
        "--agent-id",
        "codex",
        "--action",
        "Recorded result",
        "--outcome",
        "executed",
        "--human-status",
        "approved",
        "--storage-dir",
        str(tmp_path / "result-storage"),
    ]


def _summary_result(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_refresh(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> List[str]:
    target = tmp_path / "refresh-target"
    code, _ = _run_cli(monkeypatch, capsys, ["install", "--runtime", "codex", "--target", str(target)], tmp_path)
    assert code == 0
    return ["refresh", "--target", str(target)]


def _summary_refresh(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_relay_status(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> List[str]:
    target = _setup_init(monkeypatch, capsys, tmp_path, "relay-target")
    return ["relay", "status", "--target", str(target)]


def _summary_relay_status(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_handoff(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> List[str]:
    target = _setup_init(monkeypatch, capsys, tmp_path, "handoff-target")
    return ["handoff", "--to", "orchestrator", "--summary", "Done", "--target", str(target)]


def _summary_handoff(payload: Dict[str, Any]) -> Dict[str, Any]:
    return payload


def _case_autoevolve(_: Path) -> List[str]:
    return ["autoevolve", "status", "--cycle", "golden-empty"]


CaseFactory = Callable[..., List[str]]
SummaryFactory = Callable[[Dict[str, Any]], Dict[str, Any]]


CLI_JSON_CASES: List[Tuple[str, CaseFactory, SummaryFactory, Dict[str, Any]]] = [
    (
        "run",
        _case_run,
        _summary_run,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "hbn_activated": False,
            "stage": "idle",
            "activation": {
                "hbn_activated": False,
                "matched_text": None,
                "normalized_trigger": None,
                "signal": "usehbn",
                "span": None,
                "stage": "idle",
                "trigger_origin": None,
            },
            "validation": {
                "checks": [
                    {
                        "message": "No HBN trigger detected in the input sentence.",
                        "name": "activation",
                        "status": "inactive",
                    }
                ],
                "status": "idle",
                "warnings": [],
            },
            "consent_status": "not_available",
            "execution": {
                "engine": "minimal_execution_engine_v0",
                "id": "<EXEC_ID>",
                "log_path": "<TMP>/run-storage/.hbn/logs/<EXEC_ID>.json",
                "started_at": "<ISO8601>",
                "state_path": "<TMP>/run-storage/.hbn/state/hbn-state.json",
            },
        },
    ),
    (
        "translate",
        _case_translate,
        _summary_translate,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "status": "translated",
            "activation": {
                "hbn_activated": True,
                "matched_text": "use hbn",
                "normalized_trigger": "usehbn",
                "signal": "usehbn",
                "span": [0, 7],
                "stage": "intent_capture",
                "trigger_origin": "natural_phrase",
            },
            "recommended_machine_path": {
                "adapter_runtime": None,
                "command": 'hbn run "use hbn analyze this system"',
                "normalized_trigger": "usehbn",
                "shell_alias_command": "use hbn analyze this system",
                "surface": "shell",
            },
            "connector_contract_status": "requires_bridge_choice",
            "connector_strategy_status": "requires_github_lookup",
            "language_fallback": {
                "effective_language_family": "c",
                "is_fallback": False,
                "source": "env_locale",
            },
        },
    ),
    (
        "connector inspect",
        _case_connector_inspect,
        _summary_connector_inspect,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "target": "<TMP>/connector-inspect",
            "contract_status": "requires_bridge_choice",
            "recommended_choice": "discover_and_build_connector",
            "remote_lookup_required": True,
            "strategy_status": "requires_github_lookup",
            "trust_level": "unknown",
        },
    ),
    (
        "connector ensure",
        _case_connector_ensure,
        _summary_connector_ensure,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "target": "<TMP>/connector-ensure",
            "status": "awaiting_remote_registry",
            "approval": {
                "approved": True,
                "choice_id": "discover_and_build_connector",
                "requires_remote_lookup": True,
            },
            "remote_resolution_status": "awaiting_remote_registry",
            "request_path": "<TMP>/connector-ensure/.hbn/connectors/requests/<REMOTE_LOOKUP_ID>.json",
        },
    ),
    (
        "init",
        _case_init,
        _summary_init,
        {
            "manifest": {
                "initialized_at": "<ISO8601>",
                "project": PROJECT,
                "protocol_version": PROTOCOL_VERSION,
                "system_type": "generic",
                "target_path": "<TMP>/init-target",
            },
            "path": "<TMP>/init-target/.hbn",
            "runtime_detection": {
                "candidates": [],
                "runtime": None,
                "signal_type": "none",
                "source": "",
            },
            "status": "initialized",
        },
    ),
    (
        "version",
        _case_version,
        _summary_version,
        {
            "cli": "hbn",
            "package_version": "0.3.0",
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
        },
    ),
    (
        "inspect",
        _case_inspect,
        _summary_inspect,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "target_path": "<TMP>/inspect-target",
            "initialized": True,
            "manifest_matches_current_version": True,
            "runtime_adapters": [],
            "runtime_detection": {
                "candidates": [],
                "runtime": None,
                "signal_type": "none",
                "source": "",
            },
            "state_path": "<TMP>/inspect-target/.hbn/state/hbn-state.json",
            "state_exists": False,
            "packaging": {
                "distribution_name": "usehbn",
                "primary_cli": "hbn",
                "pyproject_present": False,
                "setup_cfg_present": False,
            },
        },
    ),
    (
        "doctor",
        _case_doctor,
        _summary_doctor,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "status": "attention_needed",
            "target": "<TMP>/doctor-target",
            "checks": [
                {"detail": ".hbn/ is present.", "id": "initialized", "status": "pass"},
                {
                    "detail": "No runtime signal detected from target or host environment.",
                    "id": "runtime_detection",
                    "status": "warn",
                },
                {
                    "detail": "No runtime adapters installed in this target.",
                    "id": "runtime_adapters",
                    "status": "warn",
                },
                {
                    "detail": "Manifest version matches current CLI.",
                    "id": "manifest_version",
                    "status": "pass",
                },
                {"detail": "No pending readbacks.", "id": "pending_readbacks", "status": "pass"},
            ],
            "warnings": ["Target has no installed runtime adapter."],
            "next_steps": [
                "hbn doctor --target <TMP>/doctor-target",
                "hbn inspect --target <TMP>/doctor-target",
                'hbn run "use hbn analyze this system"',
                "hbn relay status --target <TMP>/doctor-target",
            ],
        },
    ),
    (
        "quickstart",
        _case_quickstart,
        _summary_quickstart,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "status": "ready",
            "target": "<TMP>/quickstart-target",
            "initialized": True,
            "init_result": "initialized",
            "adapter_installed": None,
            "quickstart_note": "<TMP>/quickstart-target/.hbn/relay/0001-Quickstart.md",
            "next_steps": [
                "hbn doctor --target <TMP>/quickstart-target",
                "hbn inspect --target <TMP>/quickstart-target",
                'hbn run "use hbn analyze this system"',
                "hbn relay status --target <TMP>/quickstart-target",
            ],
            "safe_testing_note": "Use this target only for local protocol validation. No deployment is performed by quickstart.",
        },
    ),
    (
        "install",
        _case_install,
        _summary_install,
        {
            "adapter_installation": {
                "path": "<TMP>/install-target/skills/hbn/SKILL.md",
                "runtime": "codex",
                "status": "installed",
                "target_path": "<TMP>/install-target",
            },
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
        },
    ),
    (
        "attention",
        _case_attention,
        _summary_attention,
        {
            "attention_preferences": {
                "choices": {"a": "silent", "b": "flash"},
                "enabled_for": ["security_blocked_suggestion", "human_decision"],
                "mode": "flash",
                "sound_name": "leak",
            },
            "human_prompt": "Digite A para retirar o aviso sonoro ou digite B para apenas piscar a tela quando terminar.",
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
        },
    ),
    (
        "notify",
        _case_notify,
        _summary_notify,
        {
            "notification": {
                "choice_commands": {
                    "A": "hbn attention --mode silent",
                    "B": "hbn attention --mode flash",
                },
                "event": "human_decision",
                "guidance": "O Human Brain Net solicita análise humana antes da próxima ação automática.",
                "human_prompt": "Digite A para retirar o aviso sonoro ou digite B para apenas piscar a tela quando terminar.",
                "label": "🟡 HBN NEEDS HUMAN DECISION",
                "message": "decide",
                "mode": "silent",
                "sound_name": "leak",
            },
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
        },
    ),
    (
        "readback",
        _case_readback,
        _summary_readback,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "readback_record": {
                "action_plan": ["Test CLI"],
                "agent_id": "codex",
                "classification_basis": {
                    "has_constraints": False,
                    "has_guardian_warnings": False,
                    "has_risks": False,
                },
                "created_at": "<ISO8601>",
                "execution_id": "exec-rb",
                "hearback_status": "pending",
                "invariants_preserved": ["Keep contract"],
                "protocol_version": PROTOCOL_VERSION,
                "readback_id": "readback-exec-rb",
                "residual_risks": [],
                "track": "fast_track",
                "understanding": "Understand",
            },
        },
    ),
    (
        "hearback",
        _case_hearback,
        _summary_hearback,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "readback_record": {
                "action_plan": ["Test CLI"],
                "agent_id": "codex",
                "classification_basis": {
                    "has_constraints": False,
                    "has_guardian_warnings": False,
                    "has_risks": False,
                },
                "created_at": "<ISO8601>",
                "execution_id": "exec-rb",
                "hearback_status": "confirmed",
                "invariants_preserved": ["Keep contract"],
                "protocol_version": PROTOCOL_VERSION,
                "readback_id": "readback-exec-rb",
                "residual_risks": [],
                "track": "fast_track",
                "understanding": "Understand",
            },
        },
    ),
    (
        "result",
        _case_result,
        _summary_result,
        {
            "erp_record": {
                "action_taken": "Recorded result",
                "created_at": "<ISO8601>",
                "hbn_outcome": "executed",
                "human_decision": {"status": "approved"},
                "intent_risk_profile": {
                    "abandonment_or_resource_loss_risk": False,
                    "agi_resource_shift": False,
                    "curiosity_driven": False,
                    "deception": False,
                    "ethical_break": False,
                    "financial_survival_risk": False,
                    "herd_behavior": False,
                    "improbable": False,
                    "random": False,
                },
                "protocol_version": PROTOCOL_VERSION,
                "traceability": {
                    "agent_id": "codex",
                    "execution_id": "exec-result",
                },
            },
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "state_path": "<TMP>/result-storage/.hbn/state/hbn-state.json",
        },
    ),
    (
        "refresh",
        _case_refresh,
        _summary_refresh,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "refreshed_adapters": [
                {
                    "path": "<TMP>/refresh-target/skills/hbn/SKILL.md",
                    "runtime": "codex",
                    "status": "force_updated",
                    "target_path": "<TMP>/refresh-target",
                }
            ],
            "target": "<TMP>/refresh-target",
        },
    ),
    (
        "relay status",
        _case_relay_status,
        _summary_relay_status,
        {
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
            "relay_status": {
                "active_iterations": [],
                "baton_owner": "unknown",
                "baton_since": None,
                "last_handoff": None,
                "pending_decisions": 0,
            },
            "target": "<TMP>/relay-target",
        },
    ),
    (
        "handoff",
        _case_handoff,
        _summary_handoff,
        {
            "handoff": {
                "archived_files": [],
                "from": "unknown",
                "summary": "Done",
                "timestamp": "<ISO8601>",
                "to": "orchestrator",
            },
            "project": PROJECT,
            "protocol_version": PROTOCOL_VERSION,
        },
    ),
]


@pytest.mark.parametrize("case_id, argv_factory, summary_factory, expected", CLI_JSON_CASES, ids=[case[0] for case in CLI_JSON_CASES])
def test_cli_json_subcommand_golden_contract(
    case_id: str,
    argv_factory: CaseFactory,
    summary_factory: SummaryFactory,
    expected: Dict[str, Any],
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    monkeypatch.delenv("CODEX_SANDBOX", raising=False)
    monkeypatch.setenv("LANG", "C")
    monkeypatch.setenv("LC_ALL", "C")
    monkeypatch.setenv("SHELL", "/bin/zsh")

    try:
        argv = argv_factory(tmp_path, monkeypatch, capsys)
    except TypeError:
        argv = argv_factory(tmp_path)

    code, raw = _run_cli(monkeypatch, capsys, argv, tmp_path)

    assert code == 0, case_id
    payload = _json_output(raw, tmp_path)
    assert summary_factory(payload) == expected


def test_cli_autoevolve_golden_contract(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    code, raw = _run_cli(monkeypatch, capsys, _case_autoevolve(tmp_path), tmp_path)

    assert code == 0
    assert raw == "(no entries for cycle golden-empty)\n"


def _assert_json_error(
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
    tmp_path: Path,
    argv: List[str],
    *,
    expected_exit_code: int,
    expected_error: str,
    expected_code: str | None = None,
) -> Dict[str, Any]:
    code, raw = _run_cli(monkeypatch, capsys, argv, tmp_path)
    payload = _json_output(raw, tmp_path)

    assert code == expected_exit_code
    assert payload["error"] == expected_error
    if expected_code is not None:
        assert payload["code"] == expected_code
    return payload


def test_cli_error_exit_code_for_handler_usage_error(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    _assert_json_error(
        monkeypatch,
        capsys,
        tmp_path,
        ["attention", "--target", str(tmp_path / "attention-error")],
        expected_exit_code=2,
        expected_error="Either --mode or --choice is required",
        expected_code="cli_error",
    )


@pytest.mark.parametrize(
    "argv, expected_error",
    [
        (["connector"], "Unknown connector subcommand. Use: hbn connector inspect|ensure"),
        (["relay"], "Unknown relay subcommand. Use: hbn relay status"),
    ],
)
def test_cli_error_exit_code_for_unknown_nested_subcommand(
    argv: List[str],
    expected_error: str,
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    _assert_json_error(
        monkeypatch,
        capsys,
        tmp_path,
        argv,
        expected_exit_code=2,
        expected_error=expected_error,
    )


def test_cli_error_exit_code_for_hearback_missing_exec_id(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    _assert_json_error(
        monkeypatch,
        capsys,
        tmp_path,
        ["hearback", "--status", "confirmed", "--storage-dir", str(tmp_path / "hearback-error")],
        expected_exit_code=2,
        expected_error="exec_id is required. Use --last to operate on the most recent pending readback.",
    )


def test_protocol_violation_exit_code_for_pending_readback_result(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    storage = tmp_path / "protocol-violation"
    code, _ = _run_cli(
        monkeypatch,
        capsys,
        [
            "readback",
            "exec-pending",
            "--agent-id",
            "codex",
            "--intent-json",
            '{"objective":"test","constraints":[],"risks":["risk"]}',
            "--track",
            "safe_track",
            "--understanding",
            "Understand",
            "--invariant",
            "Keep contract",
            "--plan-step",
            "Test CLI",
            "--storage-dir",
            str(storage),
        ],
        tmp_path,
    )
    assert code == 0

    _assert_json_error(
        monkeypatch,
        capsys,
        tmp_path,
        [
            "result",
            "exec-pending",
            "--agent-id",
            "codex",
            "--action",
            "Recorded result",
            "--outcome",
            "executed",
            "--human-status",
            "approved",
            "--storage-dir",
            str(storage),
        ],
        expected_exit_code=3,
        expected_error="HBN protocol violation: hearback_status must be confirmed before ERP creation",
        expected_code="protocol_violation",
    )


def test_protocol_violation_exit_code_for_handoff_pending_readbacks(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    target = _setup_init(monkeypatch, capsys, tmp_path, "handoff-pending")
    readbacks_dir = target / ".hbn" / "readbacks"
    readbacks_dir.mkdir(parents=True, exist_ok=True)
    (readbacks_dir / "exec-pending.json").write_text(
        json.dumps(
            {
                "readback_id": "readback-exec-pending",
                "execution_id": "exec-pending",
                "agent_id": "codex",
                "track": "safe_track",
                "hearback_status": "pending",
                "understanding": "Understand",
                "invariants_preserved": ["Keep contract"],
                "action_plan": ["Test CLI"],
                "classification_basis": {
                    "has_guardian_warnings": False,
                    "has_risks": True,
                    "has_constraints": False,
                },
                "created_at": "2026-06-16T00:00:00Z",
            }
        ),
        encoding="utf-8",
    )

    payload = _assert_json_error(
        monkeypatch,
        capsys,
        tmp_path,
        ["handoff", "--to", "orchestrator", "--summary", "Blocked", "--target", str(target)],
        expected_exit_code=3,
        expected_error="Cannot handoff: pending readbacks require hearback confirmation.",
    )
    assert payload["pending_readbacks"] == ["exec-pending"]

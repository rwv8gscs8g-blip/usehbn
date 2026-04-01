"""Runtime inspection and adapter installation helpers for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any, Dict, List, Optional

from usehbn import __version__

RUNTIME_SPECS = {
    "claude-code": {
        "relative_path": Path(".claude/commands/hbn.md"),
        "title": "Claude Code command",
    },
    "codex": {
        "relative_path": Path("skills/hbn/SKILL.md"),
        "title": "Codex skill",
    },
    "copilot": {
        "relative_path": Path(".github/copilot-instructions.md"),
        "title": "GitHub Copilot instructions",
    },
    "cursor": {
        "relative_path": Path(".cursor/rules/hbn.mdc"),
        "title": "Cursor rule",
    },
}
SUPPORTED_RUNTIMES = tuple(RUNTIME_SPECS.keys())
SEMANTIC_ANCHORS = (
    "usehbn",
    "use hbn",
    "usehbn.com",
    "usehbn.org",
)

HBN_STATUS_MARKERS = (
    "✅ HBN ACTIVE",
    "❌ HBN SECURITY BLOCKED SUGGESTION",
    "🟡 HBN NEEDS HUMAN DECISION",
)


def detect_runtime_from_env(target: Path) -> Optional[str]:
    """Detect the most likely AI runtime from environment signals.

    Detection order (strongest signal first):
    - CODEX_SANDBOX env var → codex
    - .claude/ directory in target → claude-code
    - .cursor/ directory in target → cursor
    - .github/ directory in target → copilot (weakest signal)
    """
    resolved = Path(target).expanduser().resolve()
    if os.environ.get("CODEX_SANDBOX"):
        return "codex"
    if (resolved / ".claude").is_dir():
        return "claude-code"
    if (resolved / ".cursor").is_dir():
        return "cursor"
    if (resolved / ".github").is_dir():
        return "copilot"
    return None


def runtime_adapter_path(runtime: str, target: Path) -> Path:
    if runtime not in RUNTIME_SPECS:
        raise ValueError(f"Unsupported runtime: {runtime}")
    return target / RUNTIME_SPECS[runtime]["relative_path"]


def _adapter_body(runtime: str) -> str:
    return "\n".join(
        [
            f"# HBN Runtime Adapter for {RUNTIME_SPECS[runtime]['title']}",
            "",
            "HBN — Human Brain Net",
            f"Adapter protocol version: {__version__}",
            "",
            "Semantic anchors:",
            "- `usehbn`",
            "- `use hbn`",
            "- `usehbn.com`",
            "- `usehbn.org`",
            "",
            "Interpret these anchors as references to the HBN protocol layer.",
            "Normalize them internally to `usehbn` before selecting the correct local command path.",
            "The domains are canonical semantic references, not a requirement to browse the web.",
            "",
            "Visible HBN response modes:",
            "- `✅ HBN ACTIVE` when the protocol is engaged and work may proceed.",
            "- `❌ HBN SECURITY BLOCKED SUGGESTION` when a protocol gate, validation, or environment dependency blocks progress provisionally for safety and conformity.",
            "- `🟡 HBN NEEDS HUMAN DECISION` when approval or a policy choice is required before continuing.",
            "",
            "At the start of each HBN-governed cycle, present a short visible readback containing:",
            "1. HBN status marker.",
            "2. `🧠 Entendimento e Escopo`.",
            "3. `🧭 Caminho Oficial`.",
            "4. `🛠️ Ação Executada`.",
            "5. `👨‍💻 Resultado DEV` or the equivalent stage result.",
            "6. `🚦 Aprovação ou Bloqueio`.",
            "7. `➡️ Próximo Passo`.",
            "8. `📝 Documentado em` with `.hbn/` file references.",
            "",
            "When working in this repository:",
            "1. If `.hbn/` is missing, run `hbn init` before protocolized work.",
            "2. Read `.hbn/relay/INDEX.md` before acting.",
            "3. Read `.hbn/knowledge/INDEX.md` when prior decisions matter.",
            "4. Read `.hbn/reports/INDEX.md` when prior output documents matter.",
            '5. Use `hbn run "<sentence>"` to structure the initial request.',
            "6. If the work is `safe_track`, create readback, wait for hearback confirmation, then record ERP.",
            "7. Record outcomes with `hbn result`.",
            "",
            "Relay and memory discipline:",
            "- Active coordination files live in `.hbn/relay/` and use `0001-Subject.md` sequential naming.",
            "- Resolved relay files move to `.hbn/relay-archive/` so active context stays small.",
            "- Reusable discoveries go to `.hbn/knowledge/` using the same numbering style.",
            "- Human-facing output summaries go to `.hbn/reports/` using the same numbering style.",
            "- Human-attention preferences live in `.hbn/attention.json`.",
            "- Before handing the baton to another AI or back to the human, do the cleanup step: summarize the cycle, keep only active relay files in `.hbn/relay/`, archive resolved relay files, and preserve reusable learning in `.hbn/knowledge/`.",
            "- Update `.hbn/relay/INDEX.md` with the current baton owner and the next explicit action when the cycle state changes materially.",
            "",
            "Read-only exploration discipline:",
            "- Prefer one grouped read-only scan approval before broad code inspection when the environment supports it.",
            "- Summarize what was understood before making changes.",
            "- Distinguish clearly between standard assistant chatter and HBN-governed output by using the HBN status marker.",
            "- When the cycle is blocked, end with the standard HBN blocking notice below.",
            "- When the cycle is blocked or needs a human decision, call `hbn notify --event security_blocked_suggestion` or `hbn notify --event human_decision` when local execution is available.",
            "- If the human asks to change alert behavior, use `hbn attention --mode sound|flash|silent`.",
            "",
            "Standard blocking notice:",
            "- `❌ HBN SECURITY BLOCKED SUGGESTION`",
            "- `Para sua segurança e conformidade, a ação da IA foi bloqueada provisoriamente pelo Human Brain Net ao aplicar pensamento humano associado ao contexto.`",
            "- `O ciclo não deve prosseguir sem passar por análise humana.`",
            "- `Isso evita promoção por caminho inseguro, interpretação incompleta ou execução fora das regras do projeto.`",
            "- `Digite A para retirar o aviso sonoro ou digite B para apenas piscar a tela quando terminar.`",
            "- `Consulte a pasta .hbn/ relevante para entender os motivos do bloqueio.`",
            "- `Se o som não tocar neste terminal, use a opção B ou ajuste com hbn attention.`",
            "",
            "Adapter refresh:",
            "- After updating the HBN repository, refresh this runtime adapter with `hbn install --runtime "
            f"{runtime} --target <path> --force`.",
            "- Or refresh all installed adapters at once with `hbn refresh --target <path>`.",
            "",
            "Do not bypass human authority, relay state, documentation updates, or HBN protocol guards.",
            "",
            "---",
            "",
            "## Fallback: If `hbn` CLI is not available",
            "",
            "If `hbn` is not on PATH, follow these rules directly:",
            "1. Create `.hbn/` with subdirectories: relay/, relay-archive/, knowledge/, reports/, readbacks/, results/",
            "2. Write relay/INDEX.md with current baton owner and next action.",
            "3. Before risky work, write a readback JSON to readbacks/ with: readback_id, execution_id, agent_id, track, hearback_status (pending), understanding, invariants_preserved, action_plan, classification_basis, created_at.",
            "4. Do NOT proceed to result recording until hearback_status is explicitly set to confirmed by the human.",
            "5. Write results to results/ with: traceability (execution_id, agent_id), hbn_outcome, human_decision (status), intent_risk_profile, action_taken, created_at, and optionally readback_id and environment.",
            "6. On handoff, archive resolved relay files to relay-archive/ and update relay/INDEX.md.",
            "7. Use the same visible HBN markers and section labels described above.",
        ]
    )


def install_runtime_adapter(runtime: str, target: Path, *, force: bool = False) -> Dict[str, Any]:
    resolved_target = Path(target).expanduser().resolve()
    adapter_path = runtime_adapter_path(runtime, resolved_target)
    if adapter_path.exists() and not force:
        return {
            "status": "already_installed",
            "runtime": runtime,
            "path": str(adapter_path),
            "target_path": str(resolved_target),
        }

    adapter_path.parent.mkdir(parents=True, exist_ok=True)
    adapter_path.write_text(_adapter_body(runtime), encoding="utf-8")
    return {
        "status": "force_updated" if adapter_path.exists() and force else "installed",
        "runtime": runtime,
        "path": str(adapter_path),
        "target_path": str(resolved_target),
    }


def detect_installed_runtimes(target: Path) -> List[Dict[str, str]]:
    resolved_target = Path(target).expanduser().resolve()
    installed: List[Dict[str, str]] = []
    for runtime, spec in RUNTIME_SPECS.items():
        path = resolved_target / spec["relative_path"]
        if path.exists():
            installed.append(
                {
                    "runtime": runtime,
                    "path": str(path),
                }
            )
    return installed


def refresh_all_adapters(target: Path) -> List[Dict[str, Any]]:
    """Refresh all installed runtime adapters in a target directory."""
    installed = detect_installed_runtimes(target)
    results: List[Dict[str, Any]] = []
    for adapter_info in installed:
        result = install_runtime_adapter(
            adapter_info["runtime"],
            target,
            force=True,
        )
        results.append(result)
    return results


def inspect_target(target: Path) -> Dict[str, Any]:
    resolved_target = Path(target).expanduser().resolve()
    hbn_dir = resolved_target / ".hbn"
    manifest_path = hbn_dir / "manifest.json"
    relay_dir = hbn_dir / "relay"
    relay_archive_dir = hbn_dir / "relay-archive"
    knowledge_dir = hbn_dir / "knowledge"
    reports_dir = hbn_dir / "reports"
    logs_dir = resolved_target / "logs"
    state_path = resolved_target / "state" / "hbn-state.json"
    pyproject_path = resolved_target / "pyproject.toml"
    setup_cfg_path = resolved_target / "setup.cfg"

    manifest = None
    if manifest_path.exists():
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))

    active_iterations = []
    if relay_dir.exists():
        active_iterations = sorted(
            path.name
            for path in relay_dir.glob("*.md")
            if path.name != "INDEX.md"
        )

    archived_iterations = []
    if relay_archive_dir.exists():
        archived_iterations = sorted(path.name for path in relay_archive_dir.glob("*.md"))

    knowledge_entries = []
    if knowledge_dir.exists():
        knowledge_entries = sorted(
            path.name
            for path in knowledge_dir.glob("*.md")
            if path.name != "INDEX.md"
        )

    reports_entries = []
    if reports_dir.exists():
        reports_entries = sorted(
            path.name
            for path in reports_dir.glob("*.md")
            if path.name != "INDEX.md"
        )

    logs_count = len(list(logs_dir.glob("*.json"))) if logs_dir.exists() else 0

    return {
        "target_path": str(resolved_target),
        "current_protocol_version": __version__,
        "initialized": hbn_dir.exists(),
        "manifest": manifest,
        "manifest_matches_current_version": (
            manifest is not None and manifest.get("protocol_version") == __version__
        ),
        "active_iterations": active_iterations,
        "archived_iterations": archived_iterations,
        "knowledge_entries": knowledge_entries,
        "reports_entries": reports_entries,
        "runtime_adapters": detect_installed_runtimes(resolved_target),
        "logs_count": logs_count,
        "state_path": str(state_path),
        "state_exists": state_path.exists(),
        "bootstrap_script_present": (resolved_target / "get-hbn").exists(),
        "packaging": {
            "pyproject_present": pyproject_path.exists(),
            "setup_cfg_present": setup_cfg_path.exists(),
            "distribution_name": "usehbn",
            "primary_cli": "hbn",
        },
    }

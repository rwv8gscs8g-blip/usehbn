"""Runtime inspection and adapter installation helpers for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List

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
            "When working in this repository:",
            "1. If `.hbn/` is missing, run `hbn init` before protocolized work.",
            "2. Read `.hbn/relay/INDEX.md` before acting.",
            "3. Read `.hbn/knowledge/INDEX.md` when prior decisions matter.",
            '4. Use `hbn run "<sentence>"` to structure the initial request.',
            "5. If the work is `safe_track`, create readback, wait for hearback confirmation, then record ERP.",
            "6. Record outcomes with `hbn result`.",
            "",
            "Do not bypass human authority, relay state, or HBN protocol guards.",
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
        "status": "installed",
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


def inspect_target(target: Path) -> Dict[str, Any]:
    resolved_target = Path(target).expanduser().resolve()
    hbn_dir = resolved_target / ".hbn"
    manifest_path = hbn_dir / "manifest.json"
    relay_dir = hbn_dir / "relay"
    relay_archive_dir = hbn_dir / "relay-archive"
    knowledge_dir = hbn_dir / "knowledge"
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

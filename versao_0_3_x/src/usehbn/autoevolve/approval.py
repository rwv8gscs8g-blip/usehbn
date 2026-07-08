"""Approval gates for autoevolve.

Auto-approve: tests passed AND diff size within budget.
Human gate: written marker file `.hbn/autoevolve/HUMAN_GATE` blocks all auto.
"""

from __future__ import annotations

from pathlib import Path

from usehbn.autoevolve.contract import MicrodeltaResult, MicrodeltaTask


HUMAN_GATE_FILE = ".hbn/autoevolve/HUMAN_GATE"


def human_gate_active(repo_root: Path | None = None) -> bool:
    base = Path(repo_root) if repo_root else Path.cwd()
    return (base / HUMAN_GATE_FILE).exists()


def approve(task: MicrodeltaTask, result: MicrodeltaResult, *, repo_root: Path | None = None) -> bool:
    if human_gate_active(repo_root) and task.approval == "auto":
        return False
    if not result.tests_passed:
        return False
    if (result.diff_added + result.diff_removed) > task.max_diff_lines:
        return False
    return True

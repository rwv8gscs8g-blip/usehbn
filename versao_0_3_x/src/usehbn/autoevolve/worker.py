"""Local worker.

The future RemoteWorker will have the same `apply(task)` signature. Today the
"apply" is a no-op stub: the actual code edits are performed by the assistant
(Opus) outside this module — the worker only validates scope and reports.
"""

from __future__ import annotations

import subprocess
from pathlib import Path
from typing import Iterable, Tuple

from usehbn.autoevolve.contract import MicrodeltaResult, MicrodeltaTask


class LocalWorker:
    def __init__(self, repo_root: Path | None = None):
        self.repo_root = Path(repo_root) if repo_root else Path.cwd()

    def validate_scope(self, task: MicrodeltaTask, touched_files: Iterable[str]) -> Tuple[bool, str]:
        """Return (ok, reason). A touched file passes if it starts with any allowed prefix."""
        prefixes = [p.rstrip("/") for p in task.files_allowed]
        for f in touched_files:
            if not any(f == p or f.startswith(p + "/") or f.startswith(p) for p in prefixes):
                return False, f"file '{f}' outside files_allowed {prefixes}"
        return True, "ok"

    def run_tests(self, selectors: Iterable[str] | None = None) -> Tuple[bool, str]:
        cmd = [".venv/bin/python", "-m", "pytest", "-q"]
        sel = list(selectors or [])
        if sel:
            cmd.extend(sel)
        try:
            proc = subprocess.run(cmd, cwd=self.repo_root, capture_output=True, text=True, timeout=120)
        except Exception as exc:  # pragma: no cover
            return False, f"pytest invocation error: {exc}"
        tail = (proc.stdout + proc.stderr).strip().splitlines()[-5:]
        return proc.returncode == 0, "\n".join(tail)

    def report(self, task: MicrodeltaTask, *, tests_passed: bool, notes: str = "") -> MicrodeltaResult:
        return MicrodeltaResult(
            task_id=task.id,
            arm=task.arm,
            slug=task.slug,
            status="ok" if tests_passed else "failed",
            tests_passed=tests_passed,
            notes=notes,
        )

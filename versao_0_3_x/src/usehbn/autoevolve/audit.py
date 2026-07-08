"""Audit trail for autoevolve cycles.

One JSONL line per microdelta result, sealed with HBN signals. The aggregator
in `hbn autoevolve audit` reads this file back into a human report.
"""

from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterable, List

from usehbn.autoevolve.contract import MicrodeltaResult
from usehbn.signals import OPERATIONAL_SIGNALS


CYCLE_SIGNALS = (
    "INTENT_DECLARED",
    "READBACK_OK",
    "EXECUTION_START",
    "EXECUTION_END",
    "AUDIT_SEALED",
) + OPERATIONAL_SIGNALS


def audit_path_for_cycle(cycle_id: str, root: Path | None = None) -> Path:
    base = Path(root) if root else Path(".hbn/autoevolve")
    base.mkdir(parents=True, exist_ok=True)
    return base / f"cycle-{cycle_id}.jsonl"


class AuditWriter:
    def __init__(self, path: Path):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)

    def record(self, result: MicrodeltaResult, signals: Iterable[str] | None = None) -> None:
        payload = result.to_dict()
        payload["ts"] = datetime.now(timezone.utc).isoformat()
        payload["signals"] = list(signals) if signals is not None else list(CYCLE_SIGNALS)
        with self.path.open("a", encoding="utf-8") as fh:
            fh.write(json.dumps(payload, ensure_ascii=False, sort_keys=True) + "\n")

    def read_all(self) -> List[dict]:
        if not self.path.exists():
            return []
        out: List[dict] = []
        with self.path.open("r", encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if line:
                    out.append(json.loads(line))
        return out


def aggregate_audit(rows: List[dict]) -> dict:
    """Pure aggregator over a list of audit records (from one or many cycles).

    Returns counts by status, by arm, and the list of failed slugs — enough
    to render either a markdown report or an HTML fragment without touching
    disk again.
    """
    by_status: dict[str, int] = {}
    by_arm: dict[str, int] = {}
    failed: List[dict] = []
    for r in rows:
        if not isinstance(r, dict):
            continue
        status = r.get("status", "unknown")
        arm = r.get("arm", "unknown")
        by_status[status] = by_status.get(status, 0) + 1
        by_arm[arm] = by_arm.get(arm, 0) + 1
        if status in ("failed", "oversized") or not r.get("tests_passed"):
            failed.append({"arm": arm, "slug": r.get("slug", ""), "status": status})
    return {
        "total": sum(by_status.values()),
        "by_status": by_status,
        "by_arm": by_arm,
        "failed": failed,
    }


def render_html_fragment(rows: List[dict], *, cycle_id: str) -> str:
    """Render an HTML fragment usable by site/autoevolve.html."""
    if not rows:
        return f'<p class="empty">No entries for cycle <code>{cycle_id}</code>.</p>\n'
    parts: List[str] = []
    parts.append('<table class="autoevolve-table">')
    parts.append('<thead><tr><th>#</th><th>Braço</th><th>Slug</th><th>Status</th>'
                 '<th>Testes</th><th>Commit</th></tr></thead>')
    parts.append('<tbody>')
    for i, r in enumerate(rows, start=1):
        status = r.get("status", "unknown")
        klass = f"status-{status}"
        tests = "✅" if r.get("tests_passed") else "❌"
        commit = (r.get("commit") or "")[:10]
        parts.append(
            f'<tr><td>{i}</td><td class="arm">{r.get("arm","")}</td>'
            f'<td>{r.get("slug","")}</td><td class="{klass}">{status}</td>'
            f'<td>{tests}</td><td><code>{commit}</code></td></tr>'
        )
    parts.append('</tbody></table>')
    return "\n".join(parts) + "\n"

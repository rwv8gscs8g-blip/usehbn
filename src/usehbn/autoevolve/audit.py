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


CYCLE_SIGNALS = (
    "INTENT_DECLARED",
    "READBACK_OK",
    "EXECUTION_START",
    "EXECUTION_END",
    "AUDIT_SEALED",
    "AUTOEVOLVE_TICK",
)


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

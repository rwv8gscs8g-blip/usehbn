"""Task and result contracts for autoevolve microdeltas.

JSON-serializable so the same shape works for a local worker today and a
remote worker (Redis/SQS/HTTP) tomorrow.
"""

from __future__ import annotations

import json
import uuid
from dataclasses import asdict, dataclass, field
from typing import Any, Dict, List, Optional


CONTRACT_VERSION = "1.0.0"


@dataclass
class MicrodeltaTask:
    arm: str
    slug: str
    spec: str
    files_allowed: List[str]
    tests_required: List[str] = field(default_factory=list)
    max_diff_lines: int = 80
    approval: str = "auto"
    id: str = field(default_factory=lambda: str(uuid.uuid4()))
    contract_version: str = CONTRACT_VERSION

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)

    def to_json(self) -> str:
        return json.dumps(self.to_dict(), ensure_ascii=False, sort_keys=True)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "MicrodeltaTask":
        allowed = {f for f in cls.__dataclass_fields__}
        return cls(**{k: v for k, v in data.items() if k in allowed})


@dataclass
class MicrodeltaResult:
    task_id: str
    arm: str
    slug: str
    status: str  # one of: ok, failed, oversized, skipped
    tests_passed: bool
    diff_added: int = 0
    diff_removed: int = 0
    commit: Optional[str] = None
    notes: str = ""
    signals: List[str] = field(default_factory=list)

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)

    def to_json(self) -> str:
        return json.dumps(self.to_dict(), ensure_ascii=False, sort_keys=True)

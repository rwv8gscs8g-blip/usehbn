"""Semantic readback logic for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List, Optional

from usehbn.utils.config import default_state_dir
from usehbn.utils.logger import write_json
from usehbn.utils.time import utc_now_iso
from usehbn.utils.validators import assert_valid_payload

READBACKS_DIRNAME = "readbacks"
TRACK_CHOICES = ("computed", "fast_track", "safe_track")
HEARBACK_STATUSES = ("pending", "confirmed", "rejected")


def _readbacks_dir(storage_dir: Optional[Path] = None) -> Path:
    readbacks_dir = default_state_dir(storage_dir) / READBACKS_DIRNAME
    readbacks_dir.mkdir(parents=True, exist_ok=True)
    return readbacks_dir


def find_readback_by_execution(execution_id: str, storage_dir: Optional[Path] = None) -> Optional[Dict[str, Any]]:
    path = _readbacks_dir(storage_dir) / f"{execution_id}.json"
    if not path.exists():
        return None
    return json.loads(path.read_text(encoding="utf-8"))


def classify_track(intent: Dict[str, Any], guardian_result: Dict[str, Any]) -> str:
    if guardian_result.get("warnings") or intent.get("risks") or intent.get("constraints"):
        return "safe_track"
    return "fast_track"


def create_readback_record(
    *,
    execution_id: str,
    agent_id: str,
    intent: Dict[str, Any],
    guardian_result: Dict[str, Any],
    understanding: str,
    invariants_preserved: List[str],
    action_plan: List[str],
    out_of_scope: Optional[List[str]] = None,
    residual_risks: Optional[List[str]] = None,
    track: str = "computed",
    hearback_status: str = "pending",
    storage_dir: Optional[Path] = None,
) -> Dict[str, Any]:
    if find_readback_by_execution(execution_id, storage_dir) is not None:
        raise ValueError("Readback already exists for this execution_id")

    computed_track = classify_track(intent, guardian_result)
    final_track = computed_track if track == "computed" else track

    record = {
        "readback_id": f"readback-{execution_id}",
        "execution_id": execution_id,
        "agent_id": agent_id,
        "track": final_track,
        "hearback_status": hearback_status,
        "understanding": understanding,
        "invariants_preserved": invariants_preserved,
        "action_plan": action_plan,
        "residual_risks": residual_risks or [],
        "classification_basis": {
            "has_guardian_warnings": bool(guardian_result.get("warnings")),
            "has_risks": bool(intent.get("risks")),
            "has_constraints": bool(intent.get("constraints")),
        },
        "created_at": utc_now_iso(),
    }
    if out_of_scope:
        record["out_of_scope"] = out_of_scope
    assert_valid_payload(record, "readback.schema.json")

    path = _readbacks_dir(storage_dir) / f"{execution_id}.json"
    write_json(path, record)
    return record


def update_hearback_status(
    execution_id: str,
    hearback_status: str,
    storage_dir: Optional[Path] = None,
) -> Dict[str, Any]:
    record = find_readback_by_execution(execution_id, storage_dir)
    if record is None:
        raise ValueError(f"HBN protocol violation: no readback exists for execution_id {execution_id}")

    record["hearback_status"] = hearback_status
    assert_valid_payload(record, "readback.schema.json")

    path = _readbacks_dir(storage_dir) / f"{execution_id}.json"
    write_json(path, record)
    return record

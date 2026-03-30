"""Execution Result Protocol logic for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List, Optional

from usehbn.protocol.readback import find_readback_by_execution
from usehbn.utils.config import default_state_dir
from usehbn.utils.logger import write_json
from usehbn.utils.time import utc_now_iso
from usehbn.utils.validators import assert_valid_payload

RESULTS_DIRNAME = "results"
RISK_FLAG_NAMES = (
    "deception",
    "improbable",
    "random",
    "herd_behavior",
    "financial_survival_risk",
    "abandonment_or_resource_loss_risk",
    "curiosity_driven",
    "agi_resource_shift",
    "ethical_break",
)


def _results_dir(storage_dir: Optional[Path] = None) -> Path:
    results_dir = default_state_dir(storage_dir) / RESULTS_DIRNAME
    results_dir.mkdir(parents=True, exist_ok=True)
    return results_dir

def create_result_record(
    *,
    execution_id: str,
    agent_id: str,
    hbn_outcome: str,
    human_status: str,
    action_taken: str,
    risk_flags: Optional[Dict[str, bool]] = None,
    review_notes: Optional[str] = None,
    evidence: Optional[List[Dict[str, str]]] = None,
    other_emergent_risk: str = "",
    readback_id: Optional[str] = None,
    storage_dir: Optional[Path] = None,
) -> Dict[str, Any]:
    readback = find_readback_by_execution(execution_id, storage_dir)
    if readback is not None and readback["hearback_status"] != "confirmed":
        raise ValueError("HBN protocol violation: hearback_status must be confirmed before ERP creation")
    if readback is not None and readback["track"] == "safe_track" and not readback_id:
        raise ValueError("HBN protocol violation: readback_id is required for safe_track ERP creation")
    if readback is not None and readback_id and readback_id != readback["readback_id"]:
        raise ValueError("HBN protocol violation: readback_id must match the existing readback for this execution_id")

    risk_profile = {name: False for name in RISK_FLAG_NAMES}
    if risk_flags:
        for name, value in risk_flags.items():
            risk_profile[name] = bool(value)
    if other_emergent_risk:
        risk_profile["other_emergent_risk"] = other_emergent_risk

    record: Dict[str, Any] = {
        "traceability": {
            "execution_id": execution_id,
            "agent_id": agent_id,
        },
        "hbn_outcome": hbn_outcome,
        "human_decision": {
            "status": human_status,
        },
        "intent_risk_profile": risk_profile,
        "action_taken": action_taken,
        "created_at": utc_now_iso(),
    }

    if review_notes is not None:
        record["human_decision"]["review_notes"] = review_notes
    if evidence:
        record["evidence"] = evidence
    if readback_id:
        record["readback_id"] = readback_id

    assert_valid_payload(record, "result.schema.json")

    output_path = _results_dir(storage_dir) / f"{execution_id}.json"
    if output_path.exists():
        raise ValueError(f"Result record already exists for execution_id: {execution_id}")
    write_json(output_path, record)
    return record


def load_result_record(execution_id: str, storage_dir: Optional[Path] = None) -> Optional[Dict[str, Any]]:
    result_path = _results_dir(storage_dir) / f"{execution_id}.json"
    if not result_path.exists():
        return None
    return json.loads(result_path.read_text(encoding="utf-8"))

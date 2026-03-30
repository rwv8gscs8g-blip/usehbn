"""Minimal execution engine for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional
from uuid import uuid4

from usehbn import __version__
from usehbn.protocol.consent import CONSENT_QUESTION, build_consent_prompt, create_consent_record
from usehbn.protocol.guardian import assess_guardian
from usehbn.protocol.intent import structure_intent
from usehbn.protocol.truth_barrier import evaluate_truth_barrier
from usehbn.state.store import append_execution_state, state_file_path
from usehbn.trigger import detect_activation
from usehbn.utils.config import logs_dir
from usehbn.utils.logger import write_json


def _execution_id() -> str:
    return f"exec-{datetime.now(timezone.utc):%Y%m%dT%H%M%SZ}-{uuid4().hex[:8]}"


def _validation_summary(
    activation: Dict[str, Any],
    truth_barrier: Dict[str, Any],
    guardian: Dict[str, Any],
) -> Dict[str, Any]:
    if not activation["hbn_activated"]:
        return {
            "status": "idle",
            "checks": [
                {
                    "name": "activation",
                    "status": "inactive",
                    "message": "No HBN trigger detected in the input sentence.",
                }
            ],
            "warnings": [],
        }

    checks: List[Dict[str, str]] = [
        {
            "name": "activation",
            "status": "passed",
            "message": "HBN trigger detected and execution pipeline activated.",
        },
        {
            "name": "truth_barrier",
            "status": truth_barrier["status"],
            "message": "Truth barrier applied to the structured request.",
        },
        {
            "name": "guardian",
            "status": guardian["status"],
            "message": "Guardian review applied to the structured request.",
        },
    ]

    warnings = truth_barrier["warnings"] + guardian["warnings"]
    return {
        "status": "warn" if warnings else "clear",
        "checks": checks,
        "warnings": warnings,
    }


def _decision_records(
    execution_id: str,
    result: Dict[str, Any],
) -> List[Dict[str, Any]]:
    return [
        {
            "execution_id": execution_id,
            "category": "activation",
            "decision": "activated" if result["hbn_activated"] else "ignored",
            "stage": result["stage"],
        },
        {
            "execution_id": execution_id,
            "category": "validation",
            "decision": result["validation"]["status"],
            "truth_barrier_status": result["truth_barrier"]["status"],
            "guardian_status": result["guardian"]["status"],
        },
        {
            "execution_id": execution_id,
            "category": "consent",
            "decision": result["contribution_consent_protocol"]["status"],
        },
    ]


def execute_request(
    sentence: str,
    *,
    storage_dir: Optional[Path] = None,
    consent_resolution: Optional[bool] = None,
    consent_scope: str = "language_advancement",
    consent_duration: str = "session",
    contribution_units: int = 1,
    allowed_operations: Optional[List[str]] = None,
) -> Dict[str, Any]:
    """Execute the minimal HBN protocol pipeline and persist traceability artifacts."""
    base_dir = Path(storage_dir).expanduser() if storage_dir is not None else Path.cwd()
    execution_id = _execution_id()
    started_at = datetime.now(timezone.utc).isoformat()

    activation = detect_activation(sentence)
    result: Dict[str, Any] = {
        "project": "HBN — Human Brain Net",
        "protocol_version": __version__,
        "input": sentence,
        "hbn_activated": activation["hbn_activated"],
        "stage": activation["stage"],
        "activation": activation,
    }

    consent_payload: Dict[str, Any] = build_consent_prompt()
    if not activation["hbn_activated"]:
        result["intent"] = None
        result["truth_barrier"] = {"status": "idle", "warnings": []}
        result["guardian"] = {"status": "idle", "warnings": [], "log_path": None}
        consent_payload["status"] = "not_available"
        result["contribution_consent_protocol"] = consent_payload
        result["validation"] = _validation_summary(activation, result["truth_barrier"], result["guardian"])
    else:
        intent = structure_intent(sentence, activation)
        truth_barrier = evaluate_truth_barrier(sentence, intent)
        guardian = assess_guardian(intent, truth_barrier["warnings"], storage_dir=base_dir)

        result["intent"] = intent
        result["truth_barrier"] = truth_barrier
        result["guardian"] = guardian

        if consent_resolution is True:
            consent_record = create_consent_record(
                scope=consent_scope,
                duration=consent_duration,
                contribution_units=contribution_units,
                allowed_operations=allowed_operations or ["local_storage"],
                storage_dir=base_dir,
            )
            consent_payload = {
                "status": "granted",
                "question": CONSENT_QUESTION,
                "record": consent_record,
            }
        elif consent_resolution is False:
            consent_payload["status"] = "declined"

        result["contribution_consent_protocol"] = consent_payload
        result["validation"] = _validation_summary(activation, truth_barrier, guardian)

    log_path = logs_dir(base_dir) / f"{execution_id}.json"
    result["execution"] = {
        "id": execution_id,
        "engine": "minimal_execution_engine_v0",
        "started_at": started_at,
        "log_path": str(log_path),
        "state_path": str(state_file_path(base_dir)),
    }

    log_payload = {
        "execution": result["execution"],
        "input": sentence,
        "parsed_intent": result["intent"],
        "validation_results": result["validation"],
        "output": result,
    }
    write_json(log_path, log_payload)

    append_execution_state(
        execution={
            "execution_id": execution_id,
            "started_at": started_at,
            "input": sentence,
            "hbn_activated": result["hbn_activated"],
            "stage": result["stage"],
            "validation_status": result["validation"]["status"],
            "log_path": str(log_path),
        },
        decisions=_decision_records(execution_id, result),
        context_entry={
            "execution_id": execution_id,
            "started_at": started_at,
            "input": sentence,
            "objective": result["intent"]["objective"] if result["intent"] else None,
            "constraints": result["intent"]["constraints"] if result["intent"] else [],
            "risks": result["intent"]["risks"] if result["intent"] else [],
        },
        base_dir=base_dir,
    )

    return result

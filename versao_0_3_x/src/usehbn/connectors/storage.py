"""Local storage for connector approvals, registry, and generated bridge artifacts.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, Optional
from uuid import uuid4

from usehbn.utils.logger import write_json
from usehbn.utils.time import utc_now_iso
from usehbn.utils.validators import assert_valid_payload


def connectors_root(target: Path) -> Path:
    return target / ".hbn" / "connectors"


def approvals_dir(target: Path) -> Path:
    return connectors_root(target) / "approvals"


def generated_dir(target: Path) -> Path:
    return connectors_root(target) / "generated"


def requests_dir(target: Path) -> Path:
    return connectors_root(target) / "requests"


def registry_path(target: Path) -> Path:
    return connectors_root(target) / "registry.json"


def connector_marker_path(target: Path, connector_id: str) -> Path:
    safe_name = connector_id.replace("/", ".")
    return connectors_root(target) / f"{safe_name}.json"


def ensure_connectors_tree(target: Path) -> Path:
    root = connectors_root(target)
    approvals_dir(target).mkdir(parents=True, exist_ok=True)
    generated_dir(target).mkdir(parents=True, exist_ok=True)
    requests_dir(target).mkdir(parents=True, exist_ok=True)
    if not registry_path(target).exists():
        write_json(
            registry_path(target),
            {
                "version": 1,
                "updated_at": utc_now_iso(),
                "records": [],
            },
        )
    return root


# Connector Lifecycle Registry (Onda 4 / ADR-007 §3 Connectors lifecycle)
#
# Registry-only — this is registration honesty, not enforcement. The states
# below describe the *known* status of a connector, not a finite-state machine
# that gates behavior. Lifecycle FSM with verify and transitions is reserved
# for v0.4+ via a dedicated ADR.
LIFECYCLE_STATES = (
    "detected",   # signal seen but no work done yet
    "resolved",   # connector strategy resolved (catalog match)
    "installed",  # local artifact written (bridge / marker)
    "verified",   # manual or scripted check passed (Stub today)
    "active",     # currently being consumed by the runtime
    "revoked",    # explicitly disabled by approval / human action
)
DEFAULT_LIFECYCLE_STATE = "detected"


def _normalize_lifecycle_state(value: Any) -> str:
    """Tolerant reader: anything outside LIFECYCLE_STATES coerces to default."""
    if isinstance(value, str) and value in LIFECYCLE_STATES:
        return value
    return DEFAULT_LIFECYCLE_STATE


def summarize_registry(document: Dict[str, Any]) -> Dict[str, Any]:
    """Aggregate registry records by lifecycle_state — pure, no I/O.

    Returns a dict with the total record count plus a per-state count for
    every canonical lifecycle state (zero-filled). Useful for doctor and
    autoevolve audit reports.
    """
    records = document.get("records") if isinstance(document, dict) else None
    if not isinstance(records, list):
        records = []
    counts = {state: 0 for state in LIFECYCLE_STATES}
    for record in records:
        if not isinstance(record, dict):
            continue
        state = _normalize_lifecycle_state(record.get("lifecycle_state"))
        counts[state] = counts.get(state, 0) + 1
    return {
        "total": sum(counts.values()),
        "by_lifecycle_state": counts,
    }


def load_registry(target: Path) -> Dict[str, Any]:
    ensure_connectors_tree(target)
    path = registry_path(target)
    document = json.loads(path.read_text(encoding="utf-8"))
    document.setdefault("version", 1)
    document.setdefault("updated_at", utc_now_iso())
    document.setdefault("records", [])
    # Onda 4: tolerant migration — records without lifecycle_state get default.
    for record in document["records"]:
        if isinstance(record, dict):
            record.setdefault("lifecycle_state", DEFAULT_LIFECYCLE_STATE)
    return document


def append_registry_record(target: Path, record: Dict[str, Any]) -> Path:
    ensure_connectors_tree(target)
    path = registry_path(target)
    document = load_registry(target)
    # Onda 4: ensure new records carry lifecycle_state (default "detected")
    # and reject invalid values silently with normalization.
    record.setdefault("lifecycle_state", DEFAULT_LIFECYCLE_STATE)
    record["lifecycle_state"] = _normalize_lifecycle_state(record["lifecycle_state"])
    document["records"].append(record)
    document["updated_at"] = utc_now_iso()
    write_json(path, document)
    return path


def create_connector_approval_record(
    *,
    target: Path,
    choice_id: str,
    question: str,
    approved: bool,
    allowed_operations: list[str],
    requires_remote_lookup: bool,
    descriptor_scope: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
    ensure_connectors_tree(target)
    record_id = f"connector-approval-{uuid4().hex[:10]}"
    file_path = approvals_dir(target) / f"{record_id}.json"
    record = {
        "id": record_id,
        "question": question,
        "choice_id": choice_id,
        "approved": approved,
        "allowed_operations": allowed_operations,
        "requires_remote_lookup": requires_remote_lookup,
        "descriptor_scope": descriptor_scope or {},
        "created_at": utc_now_iso(),
        "storage_path": str(file_path),
        "processing_mode": "local_only_private_by_default",
    }
    assert_valid_payload(record, "connector-approval.schema.json")
    write_json(file_path, record)
    return record


def write_connector_marker(
    *,
    target: Path,
    connector_id: str,
    status: str,
    delivery_strategy: Dict[str, Any],
    artifact: Optional[Dict[str, Any]] = None,
) -> Path:
    ensure_connectors_tree(target)
    path = connector_marker_path(target, connector_id)
    payload = {
        "connector_id": connector_id,
        "status": status,
        "updated_at": utc_now_iso(),
        "delivery_strategy": delivery_strategy,
        "artifact": artifact or {},
    }
    write_json(path, payload)
    return path


def write_remote_request(
    *,
    target: Path,
    lookup_descriptor: Dict[str, Any],
    registry_source: str,
) -> Path:
    ensure_connectors_tree(target)
    request_id = f"remote-lookup-{uuid4().hex[:10]}"
    path = requests_dir(target) / f"{request_id}.json"
    payload = {
        "id": request_id,
        "created_at": utc_now_iso(),
        "registry_source": registry_source,
        "lookup_descriptor": lookup_descriptor,
        "status": "pending",
        "privacy_mode": "anonymous_technical_descriptor_only",
    }
    write_json(path, payload)
    return path

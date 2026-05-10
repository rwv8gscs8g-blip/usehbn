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


def load_registry(target: Path) -> Dict[str, Any]:
    ensure_connectors_tree(target)
    path = registry_path(target)
    document = json.loads(path.read_text(encoding="utf-8"))
    document.setdefault("version", 1)
    document.setdefault("updated_at", utc_now_iso())
    document.setdefault("records", [])
    return document


def append_registry_record(target: Path, record: Dict[str, Any]) -> Path:
    ensure_connectors_tree(target)
    path = registry_path(target)
    document = load_registry(target)
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

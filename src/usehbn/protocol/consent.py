"""Contribution Consent Protocol (CCP) for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional
from uuid import uuid4

from usehbn.utils.config import default_state_dir
from usehbn.utils.time import utc_now_iso
from usehbn.utils.validators import assert_valid_payload

CONSENT_QUESTION = "Do you want to contribute to the advancement of the language?"


def build_consent_prompt() -> Dict[str, Any]:
    return {
        "status": "available",
        "question": CONSENT_QUESTION,
        "processing_mode": "local_only_no_background_processing",
    }


def create_consent_record(
    scope: str,
    duration: str,
    contribution_units: int,
    allowed_operations: List[str],
    revocable: bool = True,
    storage_dir: Optional[Path] = None,
) -> Dict[str, Any]:
    """Create and persist a local CCP record without background processing."""
    if contribution_units < 1:
        raise ValueError("contribution_units must be greater than zero")

    base_dir = default_state_dir(storage_dir)
    consent_dir = base_dir / "consents"
    consent_dir.mkdir(parents=True, exist_ok=True)

    record_id = f"ccp-{datetime.now(timezone.utc):%Y%m%dT%H%M%SZ}-{uuid4().hex[:8]}"
    file_path = consent_dir / f"{record_id}.json"

    record = {
        "id": record_id,
        "question": CONSENT_QUESTION,
        "scope": scope,
        "duration": duration,
        "contribution_units": contribution_units,
        "revocable": revocable,
        "allowed_operations": allowed_operations,
        "granted": True,
        "processing_mode": "local_only_no_background_processing",
        "created_at": utc_now_iso(),
        "storage_path": str(file_path),
    }
    assert_valid_payload(record, "consent.schema.json")

    file_path.write_text(json.dumps(record, indent=2, ensure_ascii=True), encoding="utf-8")
    return record

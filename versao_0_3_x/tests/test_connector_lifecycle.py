"""Tests for ADR-007 / Onda 4 — Connector Lifecycle Registry (registration only).

Iteration 7 of the autonomous roadmap (proposal 09).

Copyright 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""
import json
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.connectors.storage import (
    DEFAULT_LIFECYCLE_STATE,
    LIFECYCLE_STATES,
    append_registry_record,
    load_registry,
    registry_path,
)


def test_lifecycle_states_canonical_set():
    """Six states per ADR-007 §3 Connectors lifecycle."""
    assert LIFECYCLE_STATES == (
        "detected", "resolved", "installed", "verified", "active", "revoked"
    )
    assert DEFAULT_LIFECYCLE_STATE == "detected"


def test_load_registry_migrates_legacy_records_with_default_state():
    """Pre-Onda-4 records without lifecycle_state must read as 'detected'."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        # Manually plant a legacy registry document (no lifecycle_state on records).
        registry_path(target).parent.mkdir(parents=True, exist_ok=True)
        legacy = {
            "version": 1,
            "updated_at": "2026-04-01T00:00:00Z",
            "records": [
                {"id": "old-1", "connector_id": "vba"},
                {"id": "old-2", "connector_id": "java"},
            ],
        }
        registry_path(target).write_text(json.dumps(legacy), encoding="utf-8")

        document = load_registry(target)
        for record in document["records"]:
            assert record["lifecycle_state"] == DEFAULT_LIFECYCLE_STATE


def test_append_registry_record_sets_default_state_when_omitted():
    """New records without lifecycle_state get 'detected' on append."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        append_registry_record(target, {"id": "new-1", "connector_id": "rust"})

        document = load_registry(target)
        records = [r for r in document["records"] if r.get("id") == "new-1"]
        assert len(records) == 1
        assert records[0]["lifecycle_state"] == "detected"


def test_append_registry_record_normalizes_invalid_state():
    """Unknown lifecycle_state values are silently coerced to default (advisory)."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        append_registry_record(
            target,
            {"id": "weird-1", "connector_id": "foo", "lifecycle_state": "bogus"},
        )

        document = load_registry(target)
        records = [r for r in document["records"] if r.get("id") == "weird-1"]
        assert records[0]["lifecycle_state"] == DEFAULT_LIFECYCLE_STATE


def test_append_registry_record_preserves_valid_state():
    """Valid lifecycle_state values pass through unchanged."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        for state in LIFECYCLE_STATES:
            append_registry_record(
                target,
                {"id": f"id-{state}", "connector_id": "foo", "lifecycle_state": state},
            )

        document = load_registry(target)
        observed = {r["id"]: r["lifecycle_state"] for r in document["records"]}
        for state in LIFECYCLE_STATES:
            assert observed[f"id-{state}"] == state

"""Tests for connectors.storage.summarize_registry (iter 7 / arm connectors)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.connectors.storage import LIFECYCLE_STATES, summarize_registry


def test_empty_document_returns_zero_counts():
    out = summarize_registry({})
    assert out["total"] == 0
    for state in LIFECYCLE_STATES:
        assert out["by_lifecycle_state"][state] == 0


def test_counts_grouped_by_lifecycle_state():
    doc = {
        "records": [
            {"connector_id": "vba-1", "lifecycle_state": "detected"},
            {"connector_id": "vba-2", "lifecycle_state": "installed"},
            {"connector_id": "cobol-1", "lifecycle_state": "installed"},
            {"connector_id": "java-1", "lifecycle_state": "active"},
        ]
    }
    out = summarize_registry(doc)
    assert out["total"] == 4
    assert out["by_lifecycle_state"]["installed"] == 2
    assert out["by_lifecycle_state"]["active"] == 1
    assert out["by_lifecycle_state"]["revoked"] == 0


def test_unknown_state_coerces_to_default():
    doc = {"records": [{"connector_id": "x", "lifecycle_state": "imagined-state"}]}
    out = summarize_registry(doc)
    assert out["by_lifecycle_state"]["detected"] == 1


def test_malformed_records_are_ignored():
    doc = {"records": [{"connector_id": "ok"}, "not-a-dict", None, 42]}
    out = summarize_registry(doc)
    assert out["total"] == 1

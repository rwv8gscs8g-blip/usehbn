"""Tests for Onda 5 — state/ legacy → .usehbn/ canonical dual-read.

Iteration 8 of the autonomous roadmap (proposal 09).

Copyright 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""
import json
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.state.store import (
    _legacy_state_file_path,
    append_result_state,
    load_state_document,
    state_file_path,
)


def _result_record(execution_id: str) -> dict:
    """Minimal valid result record shape required by append_result_state."""
    return {
        "traceability": {"execution_id": execution_id, "agent_id": "test-agent"},
        "hbn_outcome": "executed",
        "human_decision": {"status": "approved"},
        "intent_risk_profile": {
            "deception": False, "improbable": False, "random": False,
            "herd_behavior": False, "financial_survival_risk": False,
            "abandonment_or_resource_loss_risk": False,
            "curiosity_driven": False, "agi_resource_shift": False,
            "ethical_break": False,
        },
        "action_taken": "test action.",
        "created_at": "2026-05-10T00:00:00Z",
    }


def test_state_file_path_now_canonical_in_usehbn():
    """Canonical write path is `.usehbn/hbn-state.json` from Onda 5 onward."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        path = state_file_path(target)
        # The path must live under `.usehbn/` (the canonical state dir from v0.3.0).
        assert ".usehbn" in path.parts
        assert path.name == "hbn-state.json"


def test_legacy_state_file_path_points_to_state_dir():
    """Legacy fallback path stays on the pre-Onda-5 `state/` directory."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        path = _legacy_state_file_path(target)
        assert "state" in path.parts
        assert path.name == "hbn-state.json"


def test_load_state_document_falls_back_to_legacy_when_only_legacy_exists():
    """Repos with state/ but no .usehbn/ keep working: legacy data is read."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        legacy_path = _legacy_state_file_path(target)
        legacy_path.parent.mkdir(parents=True, exist_ok=True)
        legacy_doc = {
            "executions": [],
            "decisions": [],
            "context_history": [],
            "results": [_result_record("exec-legacy-001")],
        }
        legacy_path.write_text(json.dumps(legacy_doc), encoding="utf-8")

        # No .usehbn/ state yet.
        assert not state_file_path(target).exists()

        document = load_state_document(target)
        result_ids = [r["traceability"]["execution_id"] for r in document["results"]]
        assert "exec-legacy-001" in result_ids


def test_load_state_document_merges_dedup_when_both_exist():
    """If both .usehbn/ and state/ exist, results dedup by execution_id (canonical wins)."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)

        legacy_path = _legacy_state_file_path(target)
        legacy_path.parent.mkdir(parents=True, exist_ok=True)
        legacy_doc = {
            "executions": [],
            "decisions": [],
            "context_history": [],
            "results": [
                _result_record("exec-shared"),
                _result_record("exec-only-legacy"),
            ],
        }
        # Mark legacy version's action_taken so we can detect canonical winning.
        legacy_doc["results"][0]["action_taken"] = "from-legacy"
        legacy_path.write_text(json.dumps(legacy_doc), encoding="utf-8")

        canonical_path = state_file_path(target)
        canonical_path.parent.mkdir(parents=True, exist_ok=True)
        canonical_doc = {
            "executions": [],
            "decisions": [],
            "context_history": [],
            "results": [
                {**_result_record("exec-shared"), "action_taken": "from-canonical"},
                _result_record("exec-only-canonical"),
            ],
        }
        canonical_path.write_text(json.dumps(canonical_doc), encoding="utf-8")

        document = load_state_document(target)
        result_ids = [r["traceability"]["execution_id"] for r in document["results"]]
        # All three execution_ids appear; shared appears once.
        assert sorted(result_ids) == [
            "exec-only-canonical", "exec-only-legacy", "exec-shared"
        ]
        # Canonical wins for the shared id.
        shared = [r for r in document["results"] if r["traceability"]["execution_id"] == "exec-shared"][0]
        assert shared["action_taken"] == "from-canonical"


def test_append_result_state_writes_only_to_canonical_dir():
    """Onda 5 contract: writes go to .usehbn/ only; legacy state/ is read-only."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        append_result_state(_result_record("exec-write-001"), base_dir=target)

        assert state_file_path(target).exists(), \
            "Canonical .usehbn/hbn-state.json must exist after append"
        # Legacy file may or may not exist (untouched); critical guarantee is that
        # we did not create a stray state/hbn-state.json with the new record.
        legacy_path = _legacy_state_file_path(target)
        if legacy_path.exists():
            legacy_doc = json.loads(legacy_path.read_text(encoding="utf-8"))
            ids = [r["traceability"]["execution_id"] for r in legacy_doc.get("results", [])]
            assert "exec-write-001" not in ids, \
                "New writes must not land in the legacy state/ dir"

"""Tests for R1 state migration: legacy dirs → `.hbn/` canonical.

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
    _legacy_usehbn_state_file_path,
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


def _decision_record(execution_id: str, source: str) -> dict:
    return {
        "traceability": {"execution_id": execution_id, "agent_id": "test-agent"},
        "category": "activation",
        "decision": "allow",
        "source": source,
    }


def _engine_decision_records(execution_id: str, source: str) -> list[dict]:
    return [
        {
            "execution_id": execution_id,
            "category": "activation",
            "decision": "activated",
            "stage": "triggered",
            "reason": "Activation marker detected.",
            "source": source,
        },
        {
            "execution_id": execution_id,
            "category": "validation",
            "decision": "valid",
            "truth_barrier_status": "passed",
            "guardian_status": "passed",
            "reason": "Truth Barrier and Guardian produced no warnings.",
            "source": source,
        },
        {
            "execution_id": execution_id,
            "category": "consent",
            "decision": "granted",
            "reason": "User opted in.",
            "source": source,
        },
    ]


def _context_record(execution_id: str, source: str) -> dict:
    return {
        "traceability": {"execution_id": execution_id, "agent_id": "test-agent"},
        "objective": "test objective",
        "source": source,
    }


def test_state_file_path_now_canonical_in_hbn_state_subdir():
    """Canonical write path is `.hbn/state/hbn-state.json` from R1 onward."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        path = state_file_path(target)
        assert ".hbn" in path.parts
        assert "state" in path.parts
        assert path.name == "hbn-state.json"


def test_legacy_state_file_paths_point_to_read_only_legacy_dirs():
    """Legacy fallbacks stay on `.usehbn/` and pre-Onda-5 `state/`."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        usehbn_path = _legacy_usehbn_state_file_path(target)
        state_path = _legacy_state_file_path(target)
        assert ".usehbn" in usehbn_path.parts
        assert usehbn_path.name == "hbn-state.json"
        assert "state" in state_path.parts
        assert state_path.name == "hbn-state.json"


def test_load_state_document_falls_back_to_usehbn_when_only_usehbn_exists():
    """Repos with `.usehbn/` but no `.hbn/state/` keep working read-only."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        legacy_path = _legacy_usehbn_state_file_path(target)
        legacy_path.parent.mkdir(parents=True, exist_ok=True)
        legacy_doc = {
            "executions": [],
            "decisions": [],
            "context_history": [],
            "results": [_result_record("exec-legacy-001")],
        }
        legacy_path.write_text(json.dumps(legacy_doc), encoding="utf-8")

        # No .hbn/state file yet.
        assert not state_file_path(target).exists()

        document = load_state_document(target)
        result_ids = [r["traceability"]["execution_id"] for r in document["results"]]
        assert "exec-legacy-001" in result_ids


def test_load_state_document_falls_back_to_state_dir_when_only_state_exists():
    """Repos with old `state/` but no `.hbn/state/` keep working read-only."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        legacy_path = _legacy_state_file_path(target)
        legacy_path.parent.mkdir(parents=True, exist_ok=True)
        legacy_path.write_text(
            json.dumps(
                {
                    "executions": [],
                    "decisions": [],
                    "context_history": [],
                    "results": [_result_record("exec-state-legacy-001")],
                }
            ),
            encoding="utf-8",
        )

        document = load_state_document(target)
        result_ids = [r["traceability"]["execution_id"] for r in document["results"]]
        assert "exec-state-legacy-001" in result_ids


def test_load_state_document_merges_dedup_when_both_exist():
    """If canonical and legacy exist, state arrays dedup by execution_id."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)

        legacy_path = _legacy_usehbn_state_file_path(target)
        legacy_path.parent.mkdir(parents=True, exist_ok=True)
        legacy_doc = {
            "executions": [],
            "decisions": [
                _decision_record("exec-shared", "from-legacy"),
                _decision_record("exec-only-legacy", "from-legacy"),
            ],
            "context_history": [
                _context_record("exec-shared", "from-legacy"),
                _context_record("exec-only-legacy", "from-legacy"),
            ],
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
            "decisions": [
                _decision_record("exec-shared", "from-canonical"),
                _decision_record("exec-only-canonical", "from-canonical"),
            ],
            "context_history": [
                _context_record("exec-shared", "from-canonical"),
                _context_record("exec-only-canonical", "from-canonical"),
            ],
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

        decision_ids = [
            item["traceability"]["execution_id"]
            for item in document["decisions"]
        ]
        assert sorted(decision_ids) == [
            "exec-only-canonical", "exec-only-legacy", "exec-shared"
        ]
        shared_decision = [
            item for item in document["decisions"]
            if item["traceability"]["execution_id"] == "exec-shared"
        ][0]
        assert shared_decision["source"] == "from-canonical"

        context_ids = [
            item["traceability"]["execution_id"]
            for item in document["context_history"]
        ]
        assert sorted(context_ids) == [
            "exec-only-canonical", "exec-only-legacy",
            "exec-shared", "exec-shared",
        ]
        shared_context_sources = [
            item["source"] for item in document["context_history"]
            if item["traceability"]["execution_id"] == "exec-shared"
        ]
        assert sorted(shared_context_sources) == ["from-canonical", "from-legacy"]


def test_load_state_document_keeps_engine_decision_categories_for_same_execution():
    """Engine writes 3 decisions with one execution_id; merge must keep all categories."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        execution_id = "exec-engine-real-001"

        canonical_decisions = _engine_decision_records(execution_id, "from-canonical")
        canonical_context = _context_record(execution_id, "from-canonical")
        canonical_path = state_file_path(target)
        canonical_path.parent.mkdir(parents=True, exist_ok=True)
        canonical_path.write_text(
            json.dumps(
                {
                    "executions": [],
                    "decisions": canonical_decisions,
                    "context_history": [canonical_context],
                    "results": [],
                }
            ),
            encoding="utf-8",
        )

        legacy_path = _legacy_usehbn_state_file_path(target)
        legacy_path.parent.mkdir(parents=True, exist_ok=True)
        legacy_path.write_text(
            json.dumps(
                {
                    "executions": [],
                    "decisions": [
                        canonical_decisions[0],
                        *_engine_decision_records(execution_id, "from-legacy"),
                    ],
                    "context_history": [
                        canonical_context,
                        _context_record(execution_id, "from-legacy"),
                    ],
                    "results": [],
                }
            ),
            encoding="utf-8",
        )

        document = load_state_document(target)

        merged_decisions = [
            item for item in document["decisions"]
            if item["execution_id"] == execution_id
        ]
        assert [item["category"] for item in merged_decisions] == [
            "activation", "validation", "consent"
        ]
        assert [item["source"] for item in merged_decisions] == [
            "from-canonical", "from-canonical", "from-canonical"
        ]

        merged_context = [
            item for item in document["context_history"]
            if item["traceability"]["execution_id"] == execution_id
        ]
        assert [item["source"] for item in merged_context] == [
            "from-canonical", "from-legacy"
        ]


def test_load_state_document_dedups_idless_items_by_content():
    """Records without execution_id dedup by deterministic content."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        shared_decision = {
            "category": "operator-note",
            "decision": "preserve-context",
            "reason": ["same", "content"],
        }
        shared_context = {
            "objective": "recover context",
            "notes": ["same", "content"],
        }

        legacy_path = _legacy_usehbn_state_file_path(target)
        legacy_path.parent.mkdir(parents=True, exist_ok=True)
        legacy_path.write_text(
            json.dumps(
                {
                    "executions": [],
                    "decisions": [
                        shared_decision,
                        {"category": "legacy-only", "decision": "keep"},
                    ],
                    "context_history": [
                        shared_context,
                        {"objective": "legacy-only"},
                    ],
                    "results": [],
                }
            ),
            encoding="utf-8",
        )

        canonical_path = state_file_path(target)
        canonical_path.parent.mkdir(parents=True, exist_ok=True)
        canonical_path.write_text(
            json.dumps(
                {
                    "executions": [],
                    "decisions": [
                        shared_decision,
                        {"category": "canonical-only", "decision": "keep"},
                    ],
                    "context_history": [
                        shared_context,
                        {"objective": "canonical-only"},
                    ],
                    "results": [],
                }
            ),
            encoding="utf-8",
        )

        document = load_state_document(target)
        assert document["decisions"].count(shared_decision) == 1
        assert document["context_history"].count(shared_context) == 1
        assert len(document["decisions"]) == 3
        assert len(document["context_history"]) == 3


def test_append_result_state_writes_only_to_canonical_dir():
    """R1 contract: writes go to `.hbn/state/` only; legacy dirs are read-only."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        append_result_state(_result_record("exec-write-001"), base_dir=target)

        assert state_file_path(target).exists(), \
            "Canonical .hbn/state/hbn-state.json must exist after append"
        for legacy_path in [_legacy_usehbn_state_file_path(target), _legacy_state_file_path(target)]:
            if legacy_path.exists():
                legacy_doc = json.loads(legacy_path.read_text(encoding="utf-8"))
                ids = [r["traceability"]["execution_id"] for r in legacy_doc.get("results", [])]
                assert "exec-write-001" not in ids, \
                    "New writes must not land in legacy state dirs"

import json
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.cli import _parse_evidence
from usehbn.protocol.result import create_result_record
from usehbn.state.store import append_result_state, load_state_document


def test_valid_erp_creation(tmp_path):
    record = create_result_record(
        execution_id="exec-123",
        agent_id="agent-codex",
        hbn_outcome="executed",
        human_status="approved",
        action_taken="Created ERP ledger entry.",
        risk_flags={"deception": True, "ethical_break": True},
        review_notes="Approved after inspection.",
        evidence=[{"type": "log", "reference": "logs/exec-123.json"}],
        storage_dir=tmp_path,
    )

    assert record["traceability"]["execution_id"] == "exec-123"
    assert record["hbn_outcome"] == "executed"
    assert record["human_decision"]["status"] == "approved"
    assert record["intent_risk_profile"]["deception"] is True
    assert record["intent_risk_profile"]["ethical_break"] is True
    assert "other_emergent_risk" not in record["intent_risk_profile"]
    assert record["created_at"].endswith("Z")
    assert "+00:00" not in record["created_at"]

    persisted = json.loads(
        (tmp_path / ".usehbn" / "results" / "exec-123.json").read_text(encoding="utf-8")
    )
    assert persisted["action_taken"] == "Created ERP ledger entry."


def test_outcome_enum_rejection(tmp_path):
    with pytest.raises(ValueError):
        create_result_record(
            execution_id="exec-124",
            agent_id="agent-codex",
            hbn_outcome="success",
            human_status="approved",
            action_taken="Invalid outcome should fail validation.",
            storage_dir=tmp_path,
        )


def test_state_append(tmp_path):
    record = create_result_record(
        execution_id="exec-125",
        agent_id="agent-codex",
        hbn_outcome="failed",
        human_status="conditional",
        action_taken="Recorded ERP failure.",
        storage_dir=tmp_path,
    )

    append_result_state(record, base_dir=tmp_path)
    state = load_state_document(tmp_path)

    assert "results" in state
    assert len(state["results"]) == 1


def test_result_overwrite_rejected(tmp_path):
    create_result_record(
        execution_id="exec-126",
        agent_id="agent-codex",
        hbn_outcome="executed",
        human_status="approved",
        action_taken="First result write.",
        storage_dir=tmp_path,
    )

    with pytest.raises(ValueError):
        create_result_record(
            execution_id="exec-126",
            agent_id="agent-codex",
            hbn_outcome="executed",
            human_status="approved",
            action_taken="Second result write should fail.",
            storage_dir=tmp_path,
        )


def test_duplicate_state_append_rejected(tmp_path):
    record = create_result_record(
        execution_id="exec-127",
        agent_id="agent-codex",
        hbn_outcome="executed_with_risk",
        human_status="conditional",
        action_taken="Append once only.",
        storage_dir=tmp_path,
    )

    append_result_state(record, base_dir=tmp_path)
    with pytest.raises(ValueError):
        append_result_state(record, base_dir=tmp_path)


def test_optional_other_emergent_risk_may_be_omitted(tmp_path):
    record = create_result_record(
        execution_id="exec-128",
        agent_id="agent-codex",
        hbn_outcome="executed",
        human_status="approved",
        action_taken="Optional field omitted.",
        storage_dir=tmp_path,
    )

    assert "other_emergent_risk" not in record["intent_risk_profile"]


def test_action_taken_max_length_enforced(tmp_path):
    with pytest.raises(ValueError):
        create_result_record(
            execution_id="exec-129",
            agent_id="agent-codex",
            hbn_outcome="executed",
            human_status="approved",
            action_taken="x" * 501,
            storage_dir=tmp_path,
        )


def test_evidence_parsing_strips_whitespace():
    evidence = _parse_evidence([" log : logs/exec-123.json "])
    assert evidence == [{"type": "log", "reference": "logs/exec-123.json"}]


def test_evidence_parsing_rejects_empty_fields():
    with pytest.raises(ValueError):
        _parse_evidence([" :logs/exec-123.json"])

    with pytest.raises(ValueError):
        _parse_evidence(["log: "])

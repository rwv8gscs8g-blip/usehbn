import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.protocol.readback import (
    classify_track,
    create_readback_record,
    find_readback_by_execution,
    update_hearback_status,
)
from usehbn.protocol.result import create_result_record


def _safe_intent():
    return {
        "objective": "analyze this system",
        "constraints": [],
        "risks": [],
        "validation_requirements": [],
    }


def _safe_guardian():
    return {
        "status": "clear",
        "warnings": [],
        "log_path": "",
    }


def test_readback_uniqueness_enforced(tmp_path):
    create_readback_record(
        execution_id="exec-readback-1",
        agent_id="agent-codex",
        intent=_safe_intent(),
        guardian_result=_safe_guardian(),
        understanding="Test understanding.",
        invariants_preserved=["Public API unchanged"],
        action_plan=["Execute planned change"],
        storage_dir=tmp_path,
    )

    with pytest.raises(ValueError, match="Readback already exists for this execution_id"):
        create_readback_record(
            execution_id="exec-readback-1",
            agent_id="agent-codex",
            intent=_safe_intent(),
            guardian_result=_safe_guardian(),
            understanding="Test understanding.",
            invariants_preserved=["Public API unchanged"],
            action_plan=["Execute planned change"],
            storage_dir=tmp_path,
        )


def test_track_is_computed_from_constraints_risks_and_warnings(tmp_path):
    constrained_intent = {
        "objective": "deploy change without downtime",
        "constraints": ["without downtime"],
        "risks": [],
        "validation_requirements": [],
    }
    record = create_readback_record(
        execution_id="exec-readback-2",
        agent_id="agent-codex",
        intent=constrained_intent,
        guardian_result=_safe_guardian(),
        understanding="Deployment requires downtime avoidance.",
        invariants_preserved=["Service remains available"],
        action_plan=["Review constrained rollout path"],
        storage_dir=tmp_path,
    )

    assert classify_track(constrained_intent, _safe_guardian()) == "safe_track"
    assert record["track"] == "safe_track"


def test_safe_track_erp_requires_confirmed_readback_and_link(tmp_path):
    risky_intent = {
        "objective": "migrate this system",
        "constraints": [],
        "risks": ["Migration work can introduce compatibility regressions."],
        "validation_requirements": [],
    }
    readback = create_readback_record(
        execution_id="exec-readback-3",
        agent_id="agent-codex",
        intent=risky_intent,
        guardian_result=_safe_guardian(),
        understanding="Migration changes can introduce compatibility risks.",
        invariants_preserved=["Public API unchanged"],
        action_plan=["Validate migration steps before execution"],
        storage_dir=tmp_path,
    )

    with pytest.raises(ValueError, match="HBN protocol violation: hearback_status must be confirmed before ERP creation"):
        create_result_record(
            execution_id="exec-readback-3",
            agent_id="agent-codex",
            hbn_outcome="blocked_by_guardian",
            human_status="conditional",
            action_taken="Attempt ERP before hearback confirmation.",
            storage_dir=tmp_path,
        )

    update_hearback_status("exec-readback-3", "confirmed", storage_dir=tmp_path)

    with pytest.raises(ValueError, match="HBN protocol violation: readback_id is required for safe_track ERP creation"):
        create_result_record(
            execution_id="exec-readback-3",
            agent_id="agent-codex",
            hbn_outcome="executed_with_risk",
            human_status="conditional",
            action_taken="Attempt ERP without readback link.",
            storage_dir=tmp_path,
        )

    result = create_result_record(
        execution_id="exec-readback-3",
        agent_id="agent-codex",
        hbn_outcome="executed_with_risk",
        human_status="conditional",
        action_taken="ERP created after confirmed hearback.",
        readback_id=readback["readback_id"],
        storage_dir=tmp_path,
    )

    assert result["readback_id"] == readback["readback_id"]


def test_hearback_blocking_applies_to_rejected_status(tmp_path):
    create_readback_record(
        execution_id="exec-readback-4",
        agent_id="agent-codex",
        intent=_safe_intent(),
        guardian_result={"status": "warn", "warnings": [{"code": "g1"}], "log_path": ""},
        understanding="Guardian warning requires safe track.",
        invariants_preserved=["No production changes"],
        action_plan=["Capture human confirmation"],
        storage_dir=tmp_path,
    )
    update_hearback_status("exec-readback-4", "rejected", storage_dir=tmp_path)
    readback = find_readback_by_execution("exec-readback-4", tmp_path)

    assert readback["hearback_status"] == "rejected"
    assert readback["track"] == "safe_track"

    with pytest.raises(ValueError, match="HBN protocol violation: hearback_status must be confirmed before ERP creation"):
        create_result_record(
            execution_id="exec-readback-4",
            agent_id="agent-codex",
            hbn_outcome="rejected",
            human_status="rejected",
            action_taken="ERP creation blocked after rejected hearback.",
            readback_id=readback["readback_id"],
            storage_dir=tmp_path,
        )


def test_readback_semantic_content_persisted(tmp_path):
    record = create_readback_record(
        execution_id="exec-readback-5",
        agent_id="agent-codex",
        intent=_safe_intent(),
        guardian_result=_safe_guardian(),
        understanding="The request is limited to analysis only.",
        invariants_preserved=["Public API unchanged"],
        action_plan=["Inspect existing modules", "Document findings"],
        out_of_scope=["Database schema changes"],
        residual_risks=["Some modules lack tests"],
        storage_dir=tmp_path,
    )

    persisted = find_readback_by_execution("exec-readback-5", tmp_path)

    assert persisted is not None
    assert persisted["readback_id"] == record["readback_id"]
    assert persisted["understanding"] == "The request is limited to analysis only."
    assert persisted["invariants_preserved"] == ["Public API unchanged"]
    assert persisted["action_plan"] == ["Inspect existing modules", "Document findings"]
    assert persisted["out_of_scope"] == ["Database schema changes"]
    assert persisted["residual_risks"] == ["Some modules lack tests"]


def test_readback_understanding_max_length(tmp_path):
    with pytest.raises(ValueError):
        create_readback_record(
            execution_id="exec-readback-6",
            agent_id="agent-codex",
            intent=_safe_intent(),
            guardian_result=_safe_guardian(),
            understanding="x" * 2001,
            invariants_preserved=["Public API unchanged"],
            action_plan=["Execute planned change"],
            storage_dir=tmp_path,
        )


def test_readback_empty_invariants_rejected(tmp_path):
    with pytest.raises(ValueError):
        create_readback_record(
            execution_id="exec-readback-7",
            agent_id="agent-codex",
            intent=_safe_intent(),
            guardian_result=_safe_guardian(),
            understanding="Test understanding.",
            invariants_preserved=[],
            action_plan=["Execute planned change"],
            storage_dir=tmp_path,
        )


def test_readback_empty_action_plan_rejected(tmp_path):
    with pytest.raises(ValueError):
        create_readback_record(
            execution_id="exec-readback-8",
            agent_id="agent-codex",
            intent=_safe_intent(),
            guardian_result=_safe_guardian(),
            understanding="Test understanding.",
            invariants_preserved=["Public API unchanged"],
            action_plan=[],
            storage_dir=tmp_path,
        )


def test_readback_out_of_scope_optional(tmp_path):
    record = create_readback_record(
        execution_id="exec-readback-9",
        agent_id="agent-codex",
        intent=_safe_intent(),
        guardian_result=_safe_guardian(),
        understanding="Test understanding.",
        invariants_preserved=["Public API unchanged"],
        action_plan=["Execute planned change"],
        storage_dir=tmp_path,
    )

    assert "out_of_scope" not in record

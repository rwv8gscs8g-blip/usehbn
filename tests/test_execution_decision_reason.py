"""Tests for execution decision_reason field (iter 6 / arm execution)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.execution.engine import execute_request


def test_decisions_carry_reason_when_activated(tmp_path: Path):
    result = execute_request("use hbn to organize the migration plan", storage_dir=tmp_path)
    log_payload_path = Path(result["execution"]["log_path"])
    assert log_payload_path.exists()
    # State store stamps decisions; verify directly via the public state document.
    from usehbn.state.store import load_state_document

    doc = load_state_document(tmp_path)
    decisions = doc.get("decisions", [])
    assert decisions, "expected execution to persist decisions"
    activations = [d for d in decisions if d.get("category") == "activation"]
    assert activations
    assert "reason" in activations[-1]
    assert "trigger" in activations[-1]["reason"].lower()


def test_decision_reason_idle_when_not_activated(tmp_path: Path):
    execute_request("normal sentence with no anchor", storage_dir=tmp_path)
    from usehbn.state.store import load_state_document

    doc = load_state_document(tmp_path)
    validations = [d for d in doc.get("decisions", []) if d.get("category") == "validation"]
    assert validations
    assert "no validation performed" in validations[-1]["reason"].lower()


def test_consent_reason_reflects_status(tmp_path: Path):
    execute_request(
        "use hbn to record consent",
        storage_dir=tmp_path,
        consent_resolution=True,
    )
    from usehbn.state.store import load_state_document

    doc = load_state_document(tmp_path)
    consents = [d for d in doc.get("decisions", []) if d.get("category") == "consent"]
    assert consents
    assert "opted in" in consents[-1]["reason"].lower()

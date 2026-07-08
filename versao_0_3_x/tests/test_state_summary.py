"""Tests for state.summarize_state_document (iter 9 / arm state)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.state.store import summarize_state_document


def test_empty_document_returns_zero_counts():
    out = summarize_state_document({})
    assert out["executions"] == 0
    assert out["decisions"] == 0
    assert out["context_history"] == 0
    assert out["results"] == 0
    assert out["total_records"] == 0


def test_counts_each_canonical_array():
    doc = {
        "executions": [{"a": 1}, {"a": 2}],
        "decisions": [{"x": 1}],
        "context_history": [],
        "results": [{"r": 1}, {"r": 2}, {"r": 3}],
    }
    out = summarize_state_document(doc)
    assert out["executions"] == 2
    assert out["decisions"] == 1
    assert out["context_history"] == 0
    assert out["results"] == 3
    assert out["total_records"] == 6


def test_non_list_values_count_as_zero():
    doc = {"executions": "broken", "decisions": None, "context_history": 42, "results": []}
    out = summarize_state_document(doc)
    assert out["total_records"] == 0


def test_non_dict_input_returns_zero_counts():
    out = summarize_state_document(None)  # type: ignore[arg-type]
    assert out["total_records"] == 0

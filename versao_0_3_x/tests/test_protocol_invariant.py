"""Regression tests for the protocol invariant snapshot (cycle 2026-05-13 / iter 2)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn import PROTOCOL_VERSION
from usehbn.protocol import PROTOCOL_LAYERS, get_protocol_invariant


def test_protocol_invariant_includes_canonical_layers():
    inv = get_protocol_invariant()
    assert inv["protocol_version"] == PROTOCOL_VERSION
    assert inv["layers"] == list(PROTOCOL_LAYERS)
    assert "activation" in inv["layers"]
    assert "guardian" in inv["layers"]


def test_protocol_invariant_marks_advisory_layers():
    inv = get_protocol_invariant()
    advisory = set(inv["advisory_layers"])
    assert "truth_barrier" in advisory
    assert "guardian" in advisory
    assert "intent" not in advisory


def test_protocol_invariant_requires_records_to_carry_protocol_version():
    inv = get_protocol_invariant()
    assert inv["records_require_protocol_version"] is True

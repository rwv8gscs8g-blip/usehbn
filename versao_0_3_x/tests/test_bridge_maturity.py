"""Tests for bridge maturity / disclaimers (iter 5 / arm bridge)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.bridge.vba import BRIDGE_DISCLAIMERS, describe_vba_bridge, list_bridge_disclaimers


def test_describe_includes_maturity_stub():
    out = describe_vba_bridge("PayrollLegacy", ["sum of net pay must equal payslip total"])
    assert out["maturity"] == "stub"
    assert out["bridge_type"] == "conceptual_only"


def test_describe_carries_disclaimers():
    out = describe_vba_bridge("X", [])
    disclaimers = out["disclaimers"]
    assert isinstance(disclaimers, list)
    assert len(disclaimers) == len(BRIDGE_DISCLAIMERS)
    assert any("Stub per MATURITY-MATRIX" in d for d in disclaimers)


def test_list_bridge_disclaimers_returns_copy():
    a = list_bridge_disclaimers()
    a.append("mutated")
    b = list_bridge_disclaimers()
    assert "mutated" not in b

"""Tests for the canonical HBN signal registry (iter 11 / arm signals)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.signals import (
    MULTI_REPO_SIGNALS,
    OPERATIONAL_SIGNALS,
    SINGLE_REPO_SIGNALS,
    all_signals,
    is_canonical_signal,
)


def test_counts_match_doctrine():
    assert len(SINGLE_REPO_SIGNALS) == 10
    assert len(MULTI_REPO_SIGNALS) == 6
    assert "AUTOEVOLVE_TICK" in OPERATIONAL_SIGNALS


def test_no_duplicates_across_groups():
    combined = list(all_signals())
    assert len(combined) == len(set(combined))


def test_membership_check():
    assert is_canonical_signal("HBN_ACTIVE") is True
    assert is_canonical_signal("AUTOEVOLVE_TICK") is True
    assert is_canonical_signal("NOT_A_SIGNAL") is False


def test_autoevolve_audit_seals_with_autoevolve_tick():
    from usehbn.autoevolve.audit import CYCLE_SIGNALS

    assert "AUTOEVOLVE_TICK" in CYCLE_SIGNALS

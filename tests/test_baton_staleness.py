"""Tests for the pure compute_baton_staleness helper (iter 3 / arm runtime)."""

from __future__ import annotations

import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.runtime import compute_baton_staleness


def test_no_policy_returns_none():
    assert compute_baton_staleness(baton_since="2026-05-13T08:00:00Z", staleness_seconds=None) is None
    assert compute_baton_staleness(baton_since="2026-05-13T08:00:00Z", staleness_seconds=-1) is None


def test_policy_configured_but_no_baton_since_returns_false():
    assert compute_baton_staleness(baton_since=None, staleness_seconds=300) is False
    assert compute_baton_staleness(baton_since="", staleness_seconds=300) is False


def test_fresh_baton_returns_false():
    now = datetime(2026, 5, 13, 12, 0, tzinfo=timezone.utc)
    since = (now - timedelta(seconds=60)).isoformat().replace("+00:00", "Z")
    assert compute_baton_staleness(baton_since=since, staleness_seconds=300, now=now) is False


def test_stale_baton_returns_true():
    now = datetime(2026, 5, 13, 12, 0, tzinfo=timezone.utc)
    since = (now - timedelta(seconds=600)).isoformat().replace("+00:00", "Z")
    assert compute_baton_staleness(baton_since=since, staleness_seconds=300, now=now) is True


def test_at_threshold_is_stale_inclusive():
    now = datetime(2026, 5, 13, 12, 0, tzinfo=timezone.utc)
    since = (now - timedelta(seconds=300)).isoformat().replace("+00:00", "Z")
    assert compute_baton_staleness(baton_since=since, staleness_seconds=300, now=now) is True


def test_malformed_baton_since_returns_true_conservatively():
    assert compute_baton_staleness(baton_since="not-a-date", staleness_seconds=300) is True

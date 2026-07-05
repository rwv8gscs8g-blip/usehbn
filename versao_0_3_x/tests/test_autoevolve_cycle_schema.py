"""Tests for the autoevolve-cycle.schema.json (iter 13 / arm schemas)."""

from __future__ import annotations

import sys
from datetime import datetime, timezone
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.utils.validators import assert_valid_payload


SCHEMA_NAME = "autoevolve-cycle.schema.json"


def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def _valid_record() -> dict:
    return {
        "task_id": "t-1",
        "arm": "translation",
        "slug": "fallback",
        "status": "ok",
        "tests_passed": True,
        "diff_added": 12,
        "diff_removed": 3,
        "commit": "abcdef1234",
        "notes": "",
        "signals": ["INTENT_DECLARED", "AUDIT_SEALED", "AUTOEVOLVE_TICK"],
        "ts": _now_iso(),
    }


def test_valid_record_passes():
    assert_valid_payload(_valid_record(), SCHEMA_NAME)


def test_missing_required_field_fails():
    rec = _valid_record()
    rec.pop("task_id")
    with pytest.raises(ValueError):
        assert_valid_payload(rec, SCHEMA_NAME)


def test_bad_status_enum_fails():
    rec = _valid_record()
    rec["status"] = "magic"
    with pytest.raises(ValueError):
        assert_valid_payload(rec, SCHEMA_NAME)


def test_empty_signals_fails_minItems():
    rec = _valid_record()
    rec["signals"] = []
    with pytest.raises(ValueError):
        assert_valid_payload(rec, SCHEMA_NAME)


def test_non_boolean_tests_passed_fails():
    rec = _valid_record()
    rec["tests_passed"] = "yes"
    with pytest.raises(ValueError):
        assert_valid_payload(rec, SCHEMA_NAME)

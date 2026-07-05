"""Tests for trigger_origin classification (iter 10 / arm trigger)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.trigger import detect_activation


def test_shorthand_usehbn_classified_as_shorthand_token():
    out = detect_activation("usehbn give me a plan")
    assert out["hbn_activated"] is True
    assert out["trigger_origin"] == "shorthand_token"


def test_natural_phrase_use_hbn_classified_as_natural_phrase():
    out = detect_activation("Please, use hbn to analyze this file.")
    assert out["hbn_activated"] is True
    assert out["trigger_origin"] == "natural_phrase"


def test_uppercase_natural_phrase_still_detected():
    out = detect_activation("USE HBN now")
    assert out["hbn_activated"] is True
    assert out["trigger_origin"] == "natural_phrase"


def test_no_trigger_has_none_origin():
    out = detect_activation("ordinary text without any anchor")
    assert out["hbn_activated"] is False
    assert out["trigger_origin"] is None


def test_empty_input_has_none_origin():
    out = detect_activation("")
    assert out["hbn_activated"] is False
    assert out["trigger_origin"] is None

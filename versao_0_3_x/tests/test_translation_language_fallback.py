"""Tests for deterministic language fallback (iter 8 / arm translation)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.translation.universal import (
    DEFAULT_FALLBACK_LANGUAGE_FAMILY,
    resolve_language_fallback,
    translate_natural_entry,
)


def test_unknown_locale_falls_back_to_en():
    out = resolve_language_fallback({"detected_language": "unknown", "language_family": "unknown"})
    assert out["effective_language_family"] == DEFAULT_FALLBACK_LANGUAGE_FAMILY
    assert out["is_fallback"] is True
    assert out["source"] == "deterministic_fallback"


def test_known_locale_passes_through():
    out = resolve_language_fallback({"detected_language": "pt-BR", "language_family": "pt"})
    assert out["effective_language_family"] == "pt"
    assert out["is_fallback"] is False
    assert out["source"] == "env_locale"


def test_empty_profile_falls_back():
    out = resolve_language_fallback({})
    assert out["is_fallback"] is True


def test_translate_natural_entry_exposes_language_fallback(tmp_path: Path):
    result = translate_natural_entry(
        "use hbn analyze",
        env={"LANG": ""},
        interface_hint="shell",
    )
    assert "language_fallback" in result
    assert result["language_fallback"]["is_fallback"] is True
    assert result["language_fallback"]["effective_language_family"] == "en"


def test_translate_natural_entry_inactive_path_also_carries_fallback():
    result = translate_natural_entry(
        "ordinary text without anchor",
        env={"LANG": ""},
        interface_hint="shell",
    )
    assert result["status"] == "inactive"
    assert "language_fallback" in result

"""Smoke test for ADR-010 deposit (iter 12 / arm methodology)."""

from __future__ import annotations

from pathlib import Path


ADR_PATH = Path(__file__).resolve().parents[1] / "methodology" / "adr" / "ADR-010-autoevolve-cycle.md"
INDEX_PATH = Path(__file__).resolve().parents[1] / "methodology" / "adr" / "INDEX.md"


def test_adr_010_file_exists():
    assert ADR_PATH.exists(), f"ADR-010 missing at {ADR_PATH}"


def test_adr_010_has_required_frontmatter_keys():
    text = ADR_PATH.read_text(encoding="utf-8")
    for key in ("adr-id: ADR-010", "status: ACCEPTED", "autor:", "data-deposito:"):
        assert key in text, f"missing frontmatter key: {key}"


def test_adr_010_listed_in_index():
    text = INDEX_PATH.read_text(encoding="utf-8")
    assert "ADR-010" in text
    assert "ADR-010-autoevolve-cycle.md" in text


def test_adr_010_mentions_14_arms_and_signals():
    text = ADR_PATH.read_text(encoding="utf-8")
    assert "14 braços" in text or "14 braços catalogados" in text
    assert "AUTOEVOLVE_TICK" in text

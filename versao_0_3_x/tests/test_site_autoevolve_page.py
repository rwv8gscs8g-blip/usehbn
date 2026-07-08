"""Smoke test for the autoevolve site page (iter 14 / arm site)."""

from __future__ import annotations

from pathlib import Path


SITE_DIR = Path(__file__).resolve().parents[1] / "site"


def test_autoevolve_page_exists():
    page = SITE_DIR / "autoevolve.html"
    assert page.exists()
    text = page.read_text(encoding="utf-8")
    assert "Autoevolve" in text
    assert "cycle 2026-05-13" in text


def test_index_links_to_autoevolve_page():
    index = (SITE_DIR / "index.html").read_text(encoding="utf-8")
    assert 'href="autoevolve.html"' in index


def test_autoevolve_page_lang_pt_br_for_human_facing_doc():
    page = (SITE_DIR / "autoevolve.html").read_text(encoding="utf-8")
    assert 'lang="pt-BR"' in page


def test_autoevolve_page_references_feynman_explainer():
    page = (SITE_DIR / "autoevolve.html").read_text(encoding="utf-8")
    assert "USEHBN-EXPLICADO" in page

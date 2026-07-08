"""Tests for aggregate_audit + render_html_fragment (iter 15 / arm audit)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.autoevolve.audit import aggregate_audit, render_html_fragment


def _row(arm: str, slug: str, status: str, passed: bool, commit: str = "deadbeef00") -> dict:
    return {
        "arm": arm,
        "slug": slug,
        "status": status,
        "tests_passed": passed,
        "commit": commit,
        "signals": ["AUTOEVOLVE_TICK"],
    }


def test_aggregate_empty_list():
    out = aggregate_audit([])
    assert out["total"] == 0
    assert out["by_status"] == {}
    assert out["failed"] == []


def test_aggregate_counts_by_status_and_arm():
    rows = [
        _row("translation", "fallback", "ok", True),
        _row("translation", "extra", "ok", True),
        _row("runtime", "stale", "failed", False),
        _row("connectors", "summary", "oversized", True),
    ]
    out = aggregate_audit(rows)
    assert out["total"] == 4
    assert out["by_status"] == {"ok": 2, "failed": 1, "oversized": 1}
    assert out["by_arm"]["translation"] == 2
    assert {f["slug"] for f in out["failed"]} == {"stale", "summary"}


def test_render_html_fragment_empty_uses_empty_class():
    html = render_html_fragment([], cycle_id="2026-05-13")
    assert "empty" in html
    assert "2026-05-13" in html


def test_render_html_fragment_includes_status_class_and_commit():
    rows = [_row("trigger", "origin", "ok", True, commit="abcdef1234567890")]
    html = render_html_fragment(rows, cycle_id="x")
    assert "status-ok" in html
    assert "abcdef1234" in html  # truncated to 10 chars
    assert "✅" in html


def test_render_html_fragment_failed_uses_failed_class():
    rows = [_row("runtime", "stale", "failed", False)]
    html = render_html_fragment(rows, cycle_id="x")
    assert "status-failed" in html
    assert "❌" in html


def test_cli_audit_html_flag_writes_html(tmp_path: Path, monkeypatch, capsys):
    monkeypatch.chdir(tmp_path)
    from usehbn.autoevolve.audit import AuditWriter, audit_path_for_cycle
    from usehbn.autoevolve.contract import MicrodeltaResult
    from usehbn.autoevolve.cli import main as autoevolve_main

    AuditWriter(audit_path_for_cycle("demo")).record(
        MicrodeltaResult(task_id="t", arm="trigger", slug="x", status="ok", tests_passed=True, commit="cafebabe11")
    )
    output_path = tmp_path / "fragment.html"
    rc = autoevolve_main(["audit", "--cycle", "demo", "--html", "--output", str(output_path)])
    assert rc == 0
    content = output_path.read_text(encoding="utf-8")
    assert "<table" in content
    assert "status-ok" in content

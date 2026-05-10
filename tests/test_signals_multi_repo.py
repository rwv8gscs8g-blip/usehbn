"""Tests for ADR-006 multi-repo HBN signals + ADR-006 §C `.hbn/meta/` creation.

Iteration 6 of the autonomous roadmap (proposal 09).

Copyright 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.cli import build_root_parser, run_init
from usehbn.runtime import HBN_STATUS_MARKERS, _adapter_body


def _parse_args(argv):
    parser = build_root_parser()
    return parser.parse_args(argv)


def test_hbn_status_markers_includes_six_multi_repo_signals():
    """ADR-006 ACCEPTED v1.1 — 6 multi-repo signals must be in the canonical list."""
    expected_multi_repo = {
        "🌐 HBN CROSS-REPO LOCK",
        "⛓️ HBN PROTOCOL DEP CHANGE",
        "🧊 HBN APP FROZEN",
        "🪞 HBN MIRROR DRIFT",
        "⏳ HBN BILLING WINDOW DRIFT",
        "🔍 HBN GROUPTHINK ALARM",
    }
    assert expected_multi_repo.issubset(set(HBN_STATUS_MARKERS)), (
        f"Missing multi-repo signals: {expected_multi_repo - set(HBN_STATUS_MARKERS)}"
    )


def test_hbn_status_markers_total_count_is_sixteen():
    """10 single-repo + 6 multi-repo = 16."""
    assert len(HBN_STATUS_MARKERS) == 16, (
        f"Expected 16 markers; got {len(HBN_STATUS_MARKERS)}: {HBN_STATUS_MARKERS}"
    )


def test_hbn_status_markers_have_no_emoji_collision():
    """No two markers can share the same emoji prefix.

    Regression guard for the original 🟠 collision between SOURCE DRIFT and
    BILLING WINDOW DRIFT (resolved by changing BILLING WINDOW DRIFT → ⏳).
    """
    emoji_prefixes = [marker.split(" ", 1)[0] for marker in HBN_STATUS_MARKERS]
    duplicates = {e for e in emoji_prefixes if emoji_prefixes.count(e) > 1}
    assert not duplicates, f"Emoji collision detected: {duplicates}"


def test_runtime_adapter_body_lists_multi_repo_signals():
    """Adapter body injected into runtime instructions mentions the multi-repo signals."""
    body = _adapter_body("claude-code")
    assert "🌐 HBN CROSS-REPO LOCK" in body
    assert "⛓️ HBN PROTOCOL DEP CHANGE" in body
    assert "🪞 HBN MIRROR DRIFT" in body
    assert "⏳ HBN BILLING WINDOW DRIFT" in body
    assert "🔍 HBN GROUPTHINK ALARM" in body


def test_hbn_init_creates_meta_directory():
    """ADR-006 §C — `.hbn/meta/` is created by `hbn init` to host signals-log.jsonl."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        run_init(_parse_args(["init", "--target", str(target)]))
        assert (target / ".hbn" / "meta").is_dir(), (
            ".hbn/meta/ must be created by hbn init per ADR-006"
        )

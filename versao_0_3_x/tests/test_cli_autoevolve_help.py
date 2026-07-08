"""Tests for hbn --help exposing autoevolve subcommand (iter 4 / arm cli)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.cli import build_root_parser


def test_root_help_lists_autoevolve():
    parser = build_root_parser()
    help_text = parser.format_help()
    assert "autoevolve" in help_text
    assert "autonomous" in help_text
    assert "evolution in v0.3.0" in help_text


def test_autoevolve_appears_in_subparsers():
    parser = build_root_parser()
    actions = [a for a in parser._actions if a.dest == "command"]
    assert actions, "expected a subparsers action keyed on 'command'"
    choices = list(actions[0].choices.keys())
    assert "autoevolve" in choices

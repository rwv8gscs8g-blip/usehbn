import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.cli import run_init, run_version


def test_hbn_init_creates_structure(tmp_path):
    args = argparse.Namespace(target=str(tmp_path), indent=2)
    result = run_init(args)

    hbn_dir = tmp_path / ".hbn"
    assert result["status"] == "initialized"
    assert hbn_dir.exists()
    assert (hbn_dir / "manifest.json").exists()
    assert (hbn_dir / "state.json").exists()
    assert (hbn_dir / "relay" / "INDEX.md").exists()
    assert (hbn_dir / "knowledge" / "INDEX.md").exists()


def test_hbn_init_idempotent(tmp_path):
    args = argparse.Namespace(target=str(tmp_path), indent=2)
    first = run_init(args)
    second = run_init(args)

    assert first["status"] == "initialized"
    assert second["status"] == "already_initialized"


def test_hbn_version_returns_primary_cli_identity():
    result = run_version(argparse.Namespace(indent=2))
    assert result["cli"] == "hbn"
    assert "protocol_version" in result

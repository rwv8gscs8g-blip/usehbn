import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.cli import run_init, run_inspect, run_install


def test_hbn_inspect_reports_uninitialized_target(tmp_path):
    result = run_inspect(argparse.Namespace(target=str(tmp_path), indent=2))

    assert result["inspection"]["initialized"] is False
    assert result["inspection"]["runtime_adapters"] == []
    assert result["inspection"]["packaging"]["pyproject_present"] is False


def test_hbn_inspect_reports_initialized_target(tmp_path):
    run_init(argparse.Namespace(target=str(tmp_path), indent=2))
    result = run_inspect(argparse.Namespace(target=str(tmp_path), indent=2))

    assert result["inspection"]["initialized"] is True
    assert result["inspection"]["manifest"]["system_type"] == "generic"
    assert result["inspection"]["manifest_matches_current_version"] is True


def test_hbn_install_runtime_adapter(tmp_path):
    result = run_install(
        argparse.Namespace(
            runtime="claude-code",
            target=str(tmp_path),
            force=False,
            indent=2,
        )
    )

    adapter_path = tmp_path / ".claude" / "commands" / "hbn.md"
    assert result["adapter_installation"]["status"] == "installed"
    assert adapter_path.exists()
    contents = adapter_path.read_text(encoding="utf-8")
    assert "HBN Runtime Adapter" in contents
    assert "usehbn.com" in contents
    assert "usehbn.org" in contents


def test_hbn_install_runtime_adapter_is_idempotent_without_force(tmp_path):
    args = argparse.Namespace(runtime="codex", target=str(tmp_path), force=False, indent=2)
    first = run_install(args)
    second = run_install(args)

    assert first["adapter_installation"]["status"] == "installed"
    assert second["adapter_installation"]["status"] == "already_installed"


def test_hbn_inspect_reports_installed_runtimes(tmp_path):
    run_init(argparse.Namespace(target=str(tmp_path), indent=2))
    run_install(argparse.Namespace(runtime="cursor", target=str(tmp_path), force=False, indent=2))
    inspection = run_inspect(argparse.Namespace(target=str(tmp_path), indent=2))

    assert inspection["inspection"]["runtime_adapters"] == [
        {
            "runtime": "cursor",
            "path": str(tmp_path / ".cursor" / "rules" / "hbn.mdc"),
        }
    ]


def test_hbn_inspect_reports_packaging_metadata_for_repo(tmp_path):
    (tmp_path / "pyproject.toml").write_text("[build-system]\nrequires = []\n", encoding="utf-8")
    (tmp_path / "setup.cfg").write_text("[metadata]\nname = test\n", encoding="utf-8")

    inspection = run_inspect(argparse.Namespace(target=str(tmp_path), indent=2))

    assert inspection["inspection"]["packaging"]["pyproject_present"] is True
    assert inspection["inspection"]["packaging"]["setup_cfg_present"] is True

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
    assert "✅ HBN ACTIVE" in contents
    assert "❌ HBN SECURITY BLOCKED SUGGESTION" in contents
    assert "🧠 Entendimento e Escopo" in contents
    assert "hbn notify --event security_blocked_suggestion" in contents
    assert "hbn attention --mode sound|flash|silent" in contents
    assert "Digite A para retirar o aviso sonoro" in contents
    assert "Before handing the baton" in contents
    assert "read-only scan approval" in contents


def test_hbn_install_runtime_adapter_for_gemini(tmp_path):
    result = run_install(
        argparse.Namespace(
            runtime="gemini",
            target=str(tmp_path),
            force=False,
            indent=2,
        )
    )

    adapter_path = tmp_path / ".gemini" / "commands" / "hbn.md"
    assert result["adapter_installation"]["status"] == "installed"
    assert adapter_path.exists()


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
    assert inspection["inspection"]["reports_entries"] == []


def test_hbn_install_refreshes_existing_hbn_guidance_files(tmp_path):
    run_init(argparse.Namespace(target=str(tmp_path), indent=2))
    relay_index = tmp_path / ".hbn" / "relay" / "INDEX.md"
    relay_index.write_text("# HBN Relay — Estado Atual\n\nNenhuma.\n", encoding="utf-8")

    run_install(argparse.Namespace(runtime="codex", target=str(tmp_path), force=True, indent=2))

    assert (tmp_path / ".hbn" / "README.md").exists()
    assert (tmp_path / ".hbn" / "reports" / "INDEX.md").exists()
    refreshed = relay_index.read_text(encoding="utf-8")
    assert "Leitura Obrigatoria Para Novas IAs" in refreshed


def test_hbn_inspect_reports_packaging_metadata_for_repo(tmp_path):
    (tmp_path / "pyproject.toml").write_text("[build-system]\nrequires = []\n", encoding="utf-8")
    (tmp_path / "setup.cfg").write_text("[metadata]\nname = test\n", encoding="utf-8")

    inspection = run_inspect(argparse.Namespace(target=str(tmp_path), indent=2))

    assert inspection["inspection"]["packaging"]["pyproject_present"] is True
    assert inspection["inspection"]["packaging"]["setup_cfg_present"] is True

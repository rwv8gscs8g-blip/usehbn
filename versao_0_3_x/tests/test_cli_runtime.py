import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.cli import run_attention, run_init, run_notify, run_version


def test_hbn_init_creates_structure(tmp_path):
    args = argparse.Namespace(target=str(tmp_path), indent=2)
    result = run_init(args)

    hbn_dir = tmp_path / ".hbn"
    assert result["status"] == "initialized"
    assert hbn_dir.exists()
    assert (hbn_dir / "manifest.json").exists()
    assert (hbn_dir / "state.json").exists()
    assert (hbn_dir / "README.md").exists()
    assert (hbn_dir / "attention.json").exists()
    assert (hbn_dir / "relay" / "INDEX.md").exists()
    assert (hbn_dir / "knowledge" / "INDEX.md").exists()
    assert (hbn_dir / "reports" / "INDEX.md").exists()

    relay_index = (hbn_dir / "relay" / "INDEX.md").read_text(encoding="utf-8")
    assert "Leitura Obrigatoria Para Novas IAs" in relay_index


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


def test_hbn_attention_updates_mode(tmp_path):
    run_init(argparse.Namespace(target=str(tmp_path), indent=2))
    result = run_attention(argparse.Namespace(target=str(tmp_path), mode="flash", choice=None, indent=2))

    assert result["attention_preferences"]["mode"] == "flash"
    assert result["human_prompt"].startswith("Digite A para retirar o aviso sonoro")


def test_hbn_attention_accepts_choice_shortcut(tmp_path):
    run_init(argparse.Namespace(target=str(tmp_path), indent=2))
    result = run_attention(argparse.Namespace(target=str(tmp_path), mode=None, choice="b", indent=2))

    assert result["attention_preferences"]["mode"] == "flash"


def test_hbn_notify_uses_preferences_and_returns_hints(tmp_path):
    run_init(argparse.Namespace(target=str(tmp_path), indent=2))
    run_attention(argparse.Namespace(target=str(tmp_path), mode="silent", choice=None, indent=2))
    result = run_notify(
        argparse.Namespace(
            target=str(tmp_path),
            event="security_blocked_suggestion",
            message="blocked for safety",
            indent=2,
        )
    )

    assert result["notification"]["mode"] == "silent"
    assert result["notification"]["label"] == "❌ HBN SECURITY BLOCKED SUGGESTION"
    assert "Para sua segurança e conformidade" in result["notification"]["guidance"]
    assert result["notification"]["human_prompt"].startswith("Digite A para retirar o aviso sonoro")
    assert result["notification"]["choice_commands"]["A"] == "hbn attention --mode silent"

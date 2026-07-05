import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.translation import detect_environment_profile, translate_natural_entry


def test_translate_natural_entry_inactive_when_no_anchor(tmp_path):
    result = translate_natural_entry("analyze this system", target=tmp_path)
    assert result["status"] == "inactive"
    assert result["recommended_machine_path"] is None
    assert "connector_contract" in result


def test_translate_natural_entry_shell_path_contains_hbn_run(tmp_path):
    result = translate_natural_entry(
        "use hbn analyze this system",
        target=tmp_path,
        interface_hint="shell",
    )
    assert result["status"] == "translated"
    assert result["recommended_machine_path"]["command"] == 'hbn run "use hbn analyze this system"'
    assert result["recommended_machine_path"]["shell_alias_command"] == "use hbn analyze this system"
    assert "connector_strategy" in result
    assert "connector_contract" in result
    assert "human_language_profile" in result["environment"]
    assert "technology_fingerprint" in result["environment"]
    assert "selected_coupling_mode" in result["connector_strategy"]["delivery_strategy"]
    assert "selected_delivery_language" in result["connector_strategy"]["delivery_strategy"]
    assert "privacy_contract" in result["connector_contract"]


def test_detect_environment_profile_prefers_adapter_file(tmp_path):
    adapter_path = tmp_path / "skills" / "hbn" / "SKILL.md"
    adapter_path.parent.mkdir(parents=True, exist_ok=True)
    adapter_path.write_text("# HBN", encoding="utf-8")

    profile = detect_environment_profile(target=tmp_path, interface_hint="shell")
    assert profile["runtime"] == "codex"
    assert profile["surface"] == "runtime_adapter"

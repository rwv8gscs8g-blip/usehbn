import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

import json

from usehbn.connectors.profiles import (
    detect_device_profile,
    detect_human_language_profile,
    detect_technology_fingerprint,
)
from usehbn.connectors.contracts import build_connector_operation_contract
from usehbn.connectors.discovery import ensure_connector_operation
from usehbn.connectors.remote import build_remote_lookup_descriptor
from usehbn.connectors.resolver import resolve_connector_strategy


def test_detect_human_language_profile_from_locale():
    profile = detect_human_language_profile({"LANG": "pt_BR.UTF-8"})
    assert profile["detected_language"] == "pt-BR"
    assert profile["language_family"] == "pt"
    assert profile["source"] == "env_locale"


def test_detect_device_profile_shell_and_os():
    profile = detect_device_profile({"SHELL": "/bin/zsh"})
    assert profile["shell"] == "zsh"
    assert profile["supports_shell_wrappers"] is True
    assert "device_id" in profile


def test_detect_technology_fingerprint_for_nextjs_vercel(tmp_path):
    (tmp_path / "package.json").write_text('{"dependencies":{"next":"16.1.6"}}', encoding="utf-8")
    (tmp_path / "vercel.json").write_text("{}", encoding="utf-8")
    fingerprint = detect_technology_fingerprint(
        target=tmp_path,
        surface="runtime_adapter",
        runtime="codex",
        device_profile={"device_id": "macos-zsh"},
        human_language_profile={"detected_language": "pt-BR", "language_family": "pt"},
    )
    assert fingerprint["target_technology_id"] == "nextjs-vercel"
    assert fingerprint["preferred_delivery_languages"][0] == "typescript"
    assert fingerprint["preferred_coupling_modes"][0] == "runtime_adapter"


def test_resolve_connector_strategy_approved_runtime():
    environment = {
        "runtime": "codex",
        "surface": "runtime_adapter",
        "technology_fingerprint": {
            "target_technology_id": "nextjs-vercel",
            "human_language": "pt-BR",
        },
    }
    resolution = resolve_connector_strategy(
        environment=environment,
        technology_fingerprint=environment["technology_fingerprint"],
    )
    assert resolution["status"] == "resolved"
    assert resolution["selected_connector"]["connector_id"] == "hbn.connector.runtime.codex"
    assert resolution["trust_policy"]["requires_human_approval"] is False
    assert resolution["delivery_strategy"]["selected_coupling_mode"] == "runtime_adapter"
    assert resolution["delivery_strategy"]["requires_host_installation"] is True


def test_resolve_connector_strategy_requires_github_lookup_for_unknown_target():
    environment = {
        "runtime": None,
        "surface": "legacy_bridge",
        "technology_fingerprint": {
            "target_technology_id": "invented-future-tech",
            "human_language": "la",
        },
    }
    resolution = resolve_connector_strategy(
        environment=environment,
        technology_fingerprint=environment["technology_fingerprint"],
    )
    assert resolution["status"] == "requires_github_lookup"
    assert resolution["trust_policy"]["requires_human_approval"] is True
    assert resolution["requested_connector_descriptor"]["target_technology_id"] == "invented-future-tech"


def test_detect_technology_fingerprint_for_cobol_prefers_target_native_delivery(tmp_path):
    (tmp_path / "program.cbl").write_text("IDENTIFICATION DIVISION.", encoding="utf-8")
    fingerprint = detect_technology_fingerprint(
        target=tmp_path,
        surface="legacy_bridge",
        runtime=None,
        device_profile={"device_id": "linux-bash"},
        human_language_profile={"detected_language": "ja-JP", "language_family": "ja"},
    )
    assert fingerprint["target_technology_id"] == "cobol"
    assert fingerprint["prefer_embedded_delivery"] is True
    assert fingerprint["preferred_delivery_languages"][0] == "cobol"


def test_detect_technology_fingerprint_for_java(tmp_path):
    (tmp_path / "pom.xml").write_text("<project></project>", encoding="utf-8")
    fingerprint = detect_technology_fingerprint(
        target=tmp_path,
        surface="legacy_bridge",
        runtime=None,
        device_profile={"device_id": "linux-bash"},
        human_language_profile={"detected_language": "pt-BR", "language_family": "pt"},
    )
    assert fingerprint["target_technology_id"] == "java"
    assert fingerprint["preferred_delivery_languages"][0] == "java"


def test_detect_technology_fingerprint_for_csharp(tmp_path):
    (tmp_path / "app.csproj").write_text("<Project />", encoding="utf-8")
    fingerprint = detect_technology_fingerprint(
        target=tmp_path,
        surface="legacy_bridge",
        runtime=None,
        device_profile={"device_id": "windows-powershell"},
        human_language_profile={"detected_language": "pt-BR", "language_family": "pt"},
    )
    assert fingerprint["target_technology_id"] == "csharp"
    assert fingerprint["preferred_delivery_languages"][0] == "csharp"


def test_resolve_connector_strategy_vba_prefers_embedded_delivery():
    environment = {
        "runtime": None,
        "surface": "legacy_bridge",
        "technology_fingerprint": {
            "surface_runtime_id": "legacy_bridge",
            "host_technology_id": "macos-zsh",
            "target_technology_id": "excel-vba",
            "human_language": "pt-BR",
            "preferred_delivery_languages": ["vba", "bas", "cls", "frm", "markdown"],
            "preferred_coupling_modes": ["embedded_target_code", "documentary_bridge"],
            "avoid_installation_when_possible": True,
            "prefer_embedded_delivery": True,
            "delivery_rationale": "Legacy Office targets work best with embedded bridge artifacts.",
        },
    }
    resolution = resolve_connector_strategy(
        environment=environment,
        technology_fingerprint=environment["technology_fingerprint"],
    )
    assert resolution["status"] == "resolved"
    assert resolution["selected_connector"]["connector_id"] == "hbn.connector.legacy.vba"
    assert resolution["delivery_strategy"]["selected_delivery_language"] == "vba"
    assert resolution["delivery_strategy"]["selected_coupling_mode"] == "embedded_target_code"
    assert resolution["delivery_strategy"]["requires_host_installation"] is False


def test_connector_contract_ready_to_assume_process_for_active_runtime():
    environment = {
        "runtime": "codex",
        "surface": "runtime_adapter",
        "target_path": "",
        "has_shell_path_access": True,
        "human_language_profile": {"language_family": "pt"},
        "technology_fingerprint": {
            "surface_runtime_id": "codex",
            "host_technology_id": "macos-zsh",
            "target_technology_id": "nextjs-vercel",
            "human_language": "pt-BR",
            "preferred_delivery_languages": ["typescript", "markdown"],
            "preferred_coupling_modes": ["runtime_adapter", "bootstrap_wrapper"],
            "avoid_installation_when_possible": False,
            "prefer_embedded_delivery": False,
            "delivery_rationale": "Modern web repos prefer runtime adapters.",
        },
    }
    resolution = resolve_connector_strategy(
        environment=environment,
        technology_fingerprint=environment["technology_fingerprint"],
    )
    contract = build_connector_operation_contract(
        environment=environment,
        connector_strategy=resolution,
    )
    assert contract["status"] == "ready_to_assume_process"
    assert contract["recommended_choice"] == "continue_with_existing_connector"
    assert contract["connector_presence"]["status"] == "active"
    assert contract["privacy_contract"]["stores_only_on_user_machine"] is True
    assert "máquina" in contract["user_messages"]["privacy_notice"]


def test_connector_contract_requires_bridge_choice_when_lookup_is_needed():
    environment = {
        "runtime": None,
        "surface": "legacy_bridge",
        "target_path": "",
        "has_shell_path_access": True,
        "human_language_profile": {"language_family": "pt"},
        "technology_fingerprint": {
            "surface_runtime_id": "legacy_bridge",
            "host_technology_id": "linux-bash",
            "target_technology_id": "invented-future-tech",
            "human_language": "pt-BR",
            "human_language_family": "pt",
            "preferred_delivery_languages": ["markdown"],
            "preferred_coupling_modes": ["documentary_bridge"],
            "avoid_installation_when_possible": True,
            "prefer_embedded_delivery": False,
            "delivery_rationale": "Unknown targets should start from explicit documentary bridges.",
        },
    }
    resolution = resolve_connector_strategy(
        environment=environment,
        technology_fingerprint=environment["technology_fingerprint"],
    )
    contract = build_connector_operation_contract(
        environment=environment,
        connector_strategy=resolution,
    )
    assert contract["status"] == "requires_bridge_choice"
    assert contract["recommended_choice"] == "discover_and_build_connector"
    assert contract["privacy_contract"]["remote_lookup"]["authorization_required"] is True
    assert contract["privacy_contract"]["remote_lookup"]["required_now"] is True
    assert contract["choices"][1]["requires_remote_lookup_approval"] is True
    assert "informar manualmente" in contract["user_messages"]["manual_entry"]


def test_ensure_connector_operation_assumes_existing_runtime_connector(tmp_path):
    adapter_path = tmp_path / "skills" / "hbn" / "SKILL.md"
    adapter_path.parent.mkdir(parents=True, exist_ok=True)
    adapter_path.write_text("# HBN", encoding="utf-8")

    result = ensure_connector_operation(
        target=tmp_path,
        interface_hint="shell",
    )
    assert result["status"] == "assumed_existing_connector"
    marker_path = Path(result["marker_path"])
    assert marker_path.exists()
    registry = json.loads((tmp_path / ".hbn" / "connectors" / "registry.json").read_text(encoding="utf-8"))
    assert registry["records"][0]["event"] == "connector_assumed_existing"


def test_ensure_connector_operation_builds_local_vba_bridge(tmp_path):
    result = ensure_connector_operation(
        target=tmp_path,
        interface_hint="legacy_bridge",
        manual_descriptor={
            "runtime_or_surface": "legacy_bridge",
            "target_technology": "excel-vba",
            "human_language": "pt-BR",
            "preferred_delivery_language": "vba",
        },
        approve_discovery=True,
    )
    assert result["status"] == "connector_ready"
    artifact_path = Path(result["activation"]["artifact"]["path"])
    assert artifact_path.exists()
    assert artifact_path.suffix == ".bas"
    assert "HBN bridge scaffold" in artifact_path.read_text(encoding="utf-8")


def test_ensure_connector_operation_creates_remote_lookup_request_without_registry(tmp_path):
    result = ensure_connector_operation(
        target=tmp_path,
        interface_hint="legacy_bridge",
        manual_descriptor={
            "runtime_or_surface": "legacy_bridge",
            "target_technology": "invented-future-tech",
            "human_language": "pt-BR",
            "preferred_delivery_language": "markdown",
        },
        approve_discovery=True,
        approve_remote_lookup=False,
    )
    assert result["status"] == "requires_remote_lookup_approval"
    request_path = Path(result["request_path"])
    assert request_path.exists()
    payload = json.loads(request_path.read_text(encoding="utf-8"))
    assert payload["privacy_mode"] == "anonymous_technical_descriptor_only"


def test_ensure_connector_operation_resolves_remote_registry_and_builds_bridge(tmp_path):
    registry_file = tmp_path / "registry.json"
    registry_file.write_text(
        json.dumps(
            {
                "connectors": [
                    {
                        "connector_id": "hbn.connector.remote.cobol",
                        "kind": "legacy_bridge",
                        "display_name": "COBOL Documentary Bridge",
                        "runtime_family": "bridge",
                        "surface_runtimes": ["legacy_bridge", "*"],
                        "supported_human_languages": ["*"],
                        "supported_target_technologies": ["cobol"],
                        "translator_impl_language": "python",
                        "delivery_languages": ["cobol", "markdown"],
                        "coupling_modes": ["embedded_target_code", "documentary_bridge"],
                        "installation_mode": "manual_or_builtin",
                        "source": {
                            "type": "github_registry",
                            "locator": "registry/connectors/cobol.json",
                            "trust_level": "review_required"
                        },
                        "requires_human_approval": True
                    }
                ]
            }
        ),
        encoding="utf-8",
    )
    result = ensure_connector_operation(
        target=tmp_path,
        interface_hint="legacy_bridge",
        manual_descriptor={
            "runtime_or_surface": "legacy_bridge",
            "target_technology": "cobol",
            "human_language": "pt-BR",
            "preferred_delivery_language": "cobol",
        },
        approve_discovery=True,
        approve_remote_lookup=True,
        registry_file=registry_file,
    )
    assert result["status"] == "connector_ready"
    artifact_path = Path(result["activation"]["artifact"]["path"])
    assert artifact_path.exists()
    assert artifact_path.suffix == ".cbl"


def test_ensure_connector_operation_builds_local_java_bridge(tmp_path):
    result = ensure_connector_operation(
        target=tmp_path,
        interface_hint="legacy_bridge",
        manual_descriptor={
            "runtime_or_surface": "legacy_bridge",
            "target_technology": "java",
            "human_language": "pt-BR",
            "preferred_delivery_language": "java",
        },
        approve_discovery=True,
    )
    assert result["status"] == "connector_ready"
    artifact_path = Path(result["activation"]["artifact"]["path"])
    assert artifact_path.exists()
    assert artifact_path.suffix == ".java"


def test_ensure_connector_operation_builds_local_csharp_bridge(tmp_path):
    result = ensure_connector_operation(
        target=tmp_path,
        interface_hint="legacy_bridge",
        manual_descriptor={
            "runtime_or_surface": "legacy_bridge",
            "target_technology": "csharp",
            "human_language": "pt-BR",
            "preferred_delivery_language": "csharp",
        },
        approve_discovery=True,
    )
    assert result["status"] == "connector_ready"
    artifact_path = Path(result["activation"]["artifact"]["path"])
    assert artifact_path.exists()
    assert artifact_path.suffix == ".cs"


def test_remote_lookup_descriptor_is_anonymized():
    connector_contract = {
        "privacy_contract": {
            "remote_lookup": {
                "allowed_payload_scope": [
                    "surface_runtime_id",
                    "host_technology_id",
                    "target_technology_id",
                    "human_language_family",
                    "preferred_delivery_language",
                    "preferred_coupling_mode",
                ]
            }
        }
    }
    connector_strategy = {
        "delivery_strategy": {
            "selected_delivery_language": "cobol",
            "selected_coupling_mode": "embedded_target_code",
        }
    }
    environment = {
        "technology_fingerprint": {
            "surface_runtime_id": "legacy_bridge",
            "host_technology_id": "linux-bash",
            "target_technology_id": "cobol",
            "human_language_family": "pt",
            "human_name": "Mauricio"
        }
    }
    descriptor = build_remote_lookup_descriptor(
        connector_contract=connector_contract,
        connector_strategy=connector_strategy,
        environment=environment,
    )
    assert "human_name" not in descriptor
    assert descriptor["target_technology_id"] == "cobol"

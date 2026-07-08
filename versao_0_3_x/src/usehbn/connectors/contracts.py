"""Operational contracts for connector activation, discovery, and privacy.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

from pathlib import Path
from typing import Any, Dict, List

from usehbn.utils.validators import assert_valid_payload


def _message_catalog(language_family: str) -> Dict[str, str]:
    if language_family == "pt":
        return {
            "existing_connector": "Uma skill ou ponte compatível já está disponível neste ambiente. O HBN pode assumir o processo e seguir com a execução do protocolo.",
            "auto_discovery": "Nenhuma ponte ativa foi encontrada. Você quer que o HBN descubra automaticamente o ambiente, identifique a tecnologia e construa a ponte mais compatível na linguagem de entrega adequada ao dispositivo ou alvo?",
            "manual_entry": "Se preferir, você pode informar manualmente o runtime, dispositivo, tecnologia de destino, linguagem humana e linguagem de entrega desejada.",
            "privacy_notice": "Por padrão, o HBN opera localmente, não coleta dados pessoais para fora da sua máquina e só consulta fontes externas com sua aprovação explícita.",
            "remote_lookup": "Para consultar um registro remoto de conectores, o HBN pedirá autorização explícita e enviará apenas um descritor técnico mínimo e anonimizado.",
        }
    return {
        "existing_connector": "A compatible skill or bridge is already available in this environment. HBN can assume the process and continue with protocol execution.",
        "auto_discovery": "No active bridge was found. Do you want HBN to discover the environment automatically, identify the technology, and build the most compatible bridge in the delivery language suited to the device or target?",
        "manual_entry": "If you prefer, you can provide the runtime, device, target technology, human language, and preferred delivery language manually.",
        "privacy_notice": "By default, HBN operates locally, does not collect personal data outside your machine, and only consults external sources with your explicit approval.",
        "remote_lookup": "If a remote connector registry lookup is needed, HBN will ask for explicit authorization and send only a minimal, anonymized technical descriptor.",
    }


def _connector_marker_path(target_path: str, connector_id: str) -> Path:
    safe_name = connector_id.replace("/", ".")
    return Path(target_path) / ".hbn" / "connectors" / f"{safe_name}.json"


def _detect_connector_presence(
    *,
    environment: Dict[str, Any],
    connector_strategy: Dict[str, Any],
) -> Dict[str, Any]:
    selected = connector_strategy.get("selected_connector")
    if not selected:
        return {
            "status": "absent",
            "evidence": [],
            "marker_path": "",
        }

    evidence: List[str] = []
    target_path = environment.get("target_path")
    marker_path = None
    if target_path:
        marker = _connector_marker_path(target_path, selected["connector_id"])
        marker_path = str(marker)
        if marker.exists():
            evidence.append("local_connector_marker")

    runtime = environment.get("runtime")
    if runtime and runtime in selected.get("surface_runtimes", []):
        evidence.append("active_runtime_signal")

    delivery = connector_strategy.get("delivery_strategy", {})
    if delivery.get("selected_coupling_mode") == "bootstrap_wrapper" and environment.get("has_shell_path_access"):
        evidence.append("host_shell_entrypoint")

    if evidence:
        return {
            "status": "active",
            "evidence": evidence,
            "marker_path": marker_path or "",
        }

    return {
        "status": "available_but_not_active",
        "evidence": [],
        "marker_path": marker_path or "",
    }


def build_connector_operation_contract(
    *,
    environment: Dict[str, Any],
    connector_strategy: Dict[str, Any],
) -> Dict[str, Any]:
    language_family = environment.get("human_language_profile", {}).get("language_family", "unknown")
    messages = _message_catalog(language_family)
    presence = _detect_connector_presence(environment=environment, connector_strategy=connector_strategy)
    trust_policy = connector_strategy.get("trust_policy", {})
    requires_remote_lookup = connector_strategy.get("status") == "requires_github_lookup"
    delivery_strategy = connector_strategy.get("delivery_strategy", {})

    if presence["status"] == "active" and not trust_policy.get("requires_human_approval", False):
        status = "ready_to_assume_process"
        recommended_choice = "continue_with_existing_connector"
    elif connector_strategy.get("status") == "resolved":
        status = "approval_required_before_build" if trust_policy.get("requires_human_approval", False) else "ready_to_build_connector"
        recommended_choice = "discover_and_build_connector"
    else:
        status = "requires_bridge_choice"
        recommended_choice = "discover_and_build_connector"

    contract = {
        "status": status,
        "recommended_choice": recommended_choice,
        "connector_presence": presence,
        "choices": [
            {
                "id": "continue_with_existing_connector",
                "available": presence["status"] == "active",
                "requires_human_approval": False,
                "question": messages["existing_connector"],
                "allowed_operations": [
                    "local_protocol_execution",
                    "local_runtime_adapter_use",
                    "local_bridge_use",
                ],
            },
            {
                "id": "discover_and_build_connector",
                "available": True,
                "requires_human_approval": True,
                "question": messages["auto_discovery"],
                "allowed_operations": [
                    "local_environment_detection",
                    "local_technology_fingerprinting",
                    "local_connector_generation",
                    "local_connector_installation",
                ],
                "requires_remote_lookup_approval": requires_remote_lookup,
            },
            {
                "id": "provide_manual_environment_descriptor",
                "available": True,
                "requires_human_approval": False,
                "question": messages["manual_entry"],
                "required_fields": [
                    "runtime_or_surface",
                    "device_or_host_technology",
                    "target_technology",
                    "human_language",
                    "preferred_delivery_language",
                ],
            },
        ],
        "privacy_contract": {
            "mode": "local_only_private_by_default",
            "stores_only_on_user_machine": True,
            "external_collection": False,
            "external_persistence_by_default": False,
            "personal_identity_required": False,
            "default_retention": "ephemeral_in_memory_and_user_local_artifacts_only",
            "gdpr_design_principles": [
                "data_minimisation",
                "purpose_limitation",
                "storage_limitation",
                "privacy_by_default",
                "local_processing_first",
            ],
            "remote_lookup": {
                "authorization_required": True,
                "required_now": requires_remote_lookup,
                "allowed_payload_scope": [
                    "surface_runtime_id",
                    "host_technology_id",
                    "target_technology_id",
                    "human_language_family",
                    "preferred_delivery_language",
                    "preferred_coupling_mode",
                ],
                "forbidden_payload_scope": [
                    "human_name",
                    "email",
                    "raw_prompt_text",
                    "repository_source_code",
                    "absolute_home_paths",
                    "personal_identifiers",
                ],
                "external_identity_mode": "anonymous_technical_descriptor_only",
            },
            "local_storage_paths": [
                ".hbn/",
                ".usehbn/",
            ],
            "notice": messages["privacy_notice"],
        },
        "user_messages": {
            "existing_connector": messages["existing_connector"],
            "auto_discovery": messages["auto_discovery"],
            "manual_entry": messages["manual_entry"],
            "privacy_notice": messages["privacy_notice"],
            "remote_lookup": messages["remote_lookup"],
        },
        "delivery_expectation": {
            "selected_delivery_language": delivery_strategy.get("selected_delivery_language") or "",
            "selected_coupling_mode": delivery_strategy.get("selected_coupling_mode") or "",
            "requires_host_installation": bool(delivery_strategy.get("requires_host_installation")),
            "delivery_target": delivery_strategy.get("delivery_target") or "documentation",
        },
    }
    assert_valid_payload(contract, "connector-contract.schema.json")
    return contract

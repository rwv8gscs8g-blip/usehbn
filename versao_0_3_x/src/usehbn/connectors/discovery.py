"""Connector discovery and build flow for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

from pathlib import Path
from typing import Any, Dict, Optional

from usehbn.bridge.vba import describe_vba_bridge
from usehbn.connectors.contracts import build_connector_operation_contract
from usehbn.connectors.profiles import build_technology_preferences
from usehbn.connectors.resolver import resolve_connector_strategy
from usehbn.connectors.remote import (
    DEFAULT_REGISTRY_SOURCE,
    build_remote_lookup_descriptor,
    resolve_remote_connector_descriptor,
)
from usehbn.connectors.storage import (
    append_registry_record,
    create_connector_approval_record,
    ensure_connectors_tree,
    write_connector_marker,
    write_remote_request,
)
from usehbn.runtime import install_runtime_adapter
from usehbn.translation.universal import detect_environment_profile
from usehbn.utils.time import utc_now_iso


def _merge_manual_descriptor(
    environment: Dict[str, Any],
    manual_descriptor: Optional[Dict[str, Any]],
) -> Dict[str, Any]:
    if not manual_descriptor:
        return environment

    merged = dict(environment)
    fingerprint = dict(environment.get("technology_fingerprint", {}))
    runtime = manual_descriptor.get("runtime_or_surface")
    if runtime:
        if runtime in {"shell", "runtime_adapter", "legacy_bridge"}:
            merged["surface"] = runtime
            merged["runtime"] = None
            fingerprint["surface_runtime_id"] = runtime
        else:
            merged["runtime"] = runtime
            fingerprint["surface_runtime_id"] = runtime
    if manual_descriptor.get("device_or_host_technology"):
        fingerprint["host_technology_id"] = manual_descriptor["device_or_host_technology"]
    if manual_descriptor.get("target_technology"):
        fingerprint["target_technology_id"] = manual_descriptor["target_technology"]
    if manual_descriptor.get("human_language"):
        fingerprint["human_language"] = manual_descriptor["human_language"]
        fingerprint["human_language_family"] = manual_descriptor["human_language"].split("-", 1)[0].lower()
        merged["human_language_profile"] = {
            "detected_language": manual_descriptor["human_language"],
            "language_family": fingerprint["human_language_family"],
            "source": "manual_descriptor",
            "confidence": 1.0,
        }
    if manual_descriptor.get("preferred_delivery_language"):
        fingerprint["preferred_delivery_languages"] = [
            manual_descriptor["preferred_delivery_language"]
        ] + [
            item
            for item in fingerprint.get("preferred_delivery_languages", [])
            if item != manual_descriptor["preferred_delivery_language"]
        ]
    preferences = build_technology_preferences(
        target_technology=fingerprint.get("target_technology_id", "generic-repository"),
        surface=merged.get("surface", "shell"),
        runtime=merged.get("runtime"),
        device_profile=merged.get("device_profile", {}),
    )
    fingerprint["technology_family"] = preferences["technology_family"]
    fingerprint["preferred_coupling_modes"] = preferences["preferred_coupling_modes"]
    fingerprint["avoid_installation_when_possible"] = preferences["avoid_installation_when_possible"]
    fingerprint["prefer_embedded_delivery"] = preferences["prefer_embedded_delivery"]
    fingerprint["delivery_rationale"] = preferences["delivery_rationale"]
    if not manual_descriptor.get("preferred_delivery_language"):
        fingerprint["preferred_delivery_languages"] = preferences["preferred_delivery_languages"]
    merged["technology_fingerprint"] = fingerprint
    return merged


def plan_connector_operation(
    *,
    target: Path,
    interface_hint: str = "shell",
    manual_descriptor: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
    environment = detect_environment_profile(target=target, interface_hint=interface_hint)
    environment = _merge_manual_descriptor(environment, manual_descriptor)
    connector_strategy = resolve_connector_strategy(
        environment=environment,
        technology_fingerprint=environment["technology_fingerprint"],
    )
    connector_contract = build_connector_operation_contract(
        environment=environment,
        connector_strategy=connector_strategy,
    )
    return {
        "environment": environment,
        "connector_strategy": connector_strategy,
        "connector_contract": connector_contract,
    }


def _comment_prefix(language: str) -> str:
    return {
        "vba": "'",
        "bas": "'",
        "cls": "'",
        "frm": "'",
        "cobol": "*",
        "copybook": "*",
        "jcl": "//",
        "pascal": "//",
        "lua": "--",
        "swift": "//",
        "python": "#",
        "java": "//",
        "csharp": "//",
        "c++": "//",
        "c": "//",
        "sh": "#",
        "zsh": "#",
        "bash": "#",
    }.get(language, "#")


def _bridge_extension(language: str) -> str:
    return {
        "vba": "bas",
        "bas": "bas",
        "cls": "cls",
        "frm": "frm",
        "cobol": "cbl",
        "copybook": "cpy",
        "jcl": "jcl",
        "pascal": "pas",
        "lua": "lua",
        "swift": "swift",
        "python": "py",
        "java": "java",
        "csharp": "cs",
        "c++": "cpp",
        "c": "c",
        "sh": "sh",
        "bash": "sh",
        "zsh": "zsh",
        "markdown": "md",
    }.get(language, "txt")


def _build_text_bridge(
    *,
    target: Path,
    connector: Dict[str, Any],
    environment: Dict[str, Any],
    delivery_strategy: Dict[str, Any],
) -> Dict[str, Any]:
    delivery_language = delivery_strategy.get("selected_delivery_language") or "markdown"
    extension = _bridge_extension(delivery_language)
    prefix = _comment_prefix(delivery_language)
    generated_path = ensure_connectors_tree(target) / "generated" / f"{connector['connector_id'].replace('/', '.')}.{extension}"

    if connector["connector_id"] == "hbn.connector.legacy.vba":
        vba_plan = describe_vba_bridge(
            system_name=environment["technology_fingerprint"]["target_technology_id"],
            invariants=["Preserve workbook behavior", "Keep business rules explicit"],
        )
        lines = [
            f"{prefix} HBN bridge scaffold for Excel/VBA",
            f"{prefix} Generated at {utc_now_iso()}",
            f"{prefix} Bridge type: {vba_plan['bridge_type']}",
            "",
            "Option Explicit" if extension == "bas" else "",
            f"{prefix} Recommended checks:",
        ] + [f"{prefix} - {item}" for item in vba_plan["recommended_checks"]]
        generated_path.write_text("\n".join(line for line in lines if line != ""), encoding="utf-8")
    else:
        lines = [
            f"{prefix} HBN bridge scaffold",
            f"{prefix} Generated at {utc_now_iso()}",
            f"{prefix} Connector: {connector['display_name']}",
            f"{prefix} Target technology: {environment['technology_fingerprint']['target_technology_id']}",
            f"{prefix} Human language: {environment['technology_fingerprint']['human_language']}",
            f"{prefix} Delivery mode: {delivery_strategy.get('selected_coupling_mode')}",
            f"{prefix} This bridge is local-only and should not export personal data.",
        ]
        generated_path.write_text("\n".join(lines), encoding="utf-8")

    return {
        "artifact_type": "generated_bridge",
        "path": str(generated_path),
        "delivery_language": delivery_language,
    }


def _activate_connector(
    *,
    target: Path,
    environment: Dict[str, Any],
    connector: Dict[str, Any],
    delivery_strategy: Dict[str, Any],
    force_rebuild: bool,
) -> Dict[str, Any]:
    coupling_mode = delivery_strategy.get("selected_coupling_mode")
    artifact: Dict[str, Any]
    if coupling_mode == "runtime_adapter" and environment.get("runtime"):
        artifact = install_runtime_adapter(environment["runtime"], target, force=force_rebuild)
    else:
        artifact = _build_text_bridge(
            target=target,
            connector=connector,
            environment=environment,
            delivery_strategy=delivery_strategy,
        )

    marker_path = write_connector_marker(
        target=target,
        connector_id=connector["connector_id"],
        status="active",
        delivery_strategy=delivery_strategy,
        artifact=artifact,
    )
    append_registry_record(
        target,
        {
            "timestamp": utc_now_iso(),
            "event": "connector_activated",
            "connector_id": connector["connector_id"],
            "delivery_strategy": delivery_strategy,
            "artifact": artifact,
            "marker_path": str(marker_path),
        },
    )
    return {
        "status": "activated",
        "marker_path": str(marker_path),
        "artifact": artifact,
    }


def ensure_connector_operation(
    *,
    target: Path,
    interface_hint: str = "shell",
    manual_descriptor: Optional[Dict[str, Any]] = None,
    approve_discovery: bool = False,
    approve_remote_lookup: bool = False,
    registry_file: Optional[Path] = None,
    force_rebuild: bool = False,
) -> Dict[str, Any]:
    target = Path(target).expanduser().resolve()
    ensure_connectors_tree(target)
    plan = plan_connector_operation(
        target=target,
        interface_hint=interface_hint,
        manual_descriptor=manual_descriptor,
    )
    environment = plan["environment"]
    connector_strategy = plan["connector_strategy"]
    connector_contract = plan["connector_contract"]

    if connector_contract["recommended_choice"] == "continue_with_existing_connector" and not force_rebuild:
        selected = connector_strategy["selected_connector"]
        marker_path = write_connector_marker(
            target=target,
            connector_id=selected["connector_id"],
            status="assumed_existing",
            delivery_strategy=connector_strategy["delivery_strategy"],
        )
        append_registry_record(
            target,
            {
                "timestamp": utc_now_iso(),
                "event": "connector_assumed_existing",
                "connector_id": selected["connector_id"],
                "marker_path": str(marker_path),
            },
        )
        return {
            "status": "assumed_existing_connector",
            "plan": plan,
            "marker_path": str(marker_path),
        }

    discovery_choice = connector_contract["choices"][1]
    if not approve_discovery:
        return {
            "status": "requires_discovery_approval",
            "plan": plan,
            "question": discovery_choice["question"],
            "privacy_notice": connector_contract["user_messages"]["privacy_notice"],
        }

    approval_record = create_connector_approval_record(
        target=target,
        choice_id=discovery_choice["id"],
        question=discovery_choice["question"],
        approved=True,
        allowed_operations=discovery_choice.get("allowed_operations", ["local_environment_detection"]),
        requires_remote_lookup=bool(discovery_choice.get("requires_remote_lookup_approval")),
        descriptor_scope=connector_strategy.get("requested_connector_descriptor"),
    )

    selected_connector = connector_strategy.get("selected_connector")
    if connector_strategy["status"] == "requires_github_lookup":
        lookup_descriptor = build_remote_lookup_descriptor(
            connector_contract=connector_contract,
            connector_strategy=connector_strategy,
            environment=environment,
        )
        if not approve_remote_lookup:
            request_path = write_remote_request(
                target=target,
                lookup_descriptor=lookup_descriptor,
                registry_source=DEFAULT_REGISTRY_SOURCE,
            )
            append_registry_record(
                target,
                {
                    "timestamp": utc_now_iso(),
                    "event": "remote_lookup_pending_approval",
                    "lookup_descriptor": lookup_descriptor,
                    "request_path": str(request_path),
                },
            )
            return {
                "status": "requires_remote_lookup_approval",
                "plan": plan,
                "approval_record": approval_record,
                "lookup_descriptor": lookup_descriptor,
                "request_path": str(request_path),
                "registry_source": DEFAULT_REGISTRY_SOURCE,
            }

        remote_resolution = resolve_remote_connector_descriptor(
            lookup_descriptor=lookup_descriptor,
            registry_file=registry_file,
        )
        request_path = write_remote_request(
            target=target,
            lookup_descriptor=lookup_descriptor,
            registry_source=remote_resolution["registry_source"],
        )
        append_registry_record(
            target,
            {
                "timestamp": utc_now_iso(),
                "event": "remote_lookup_requested",
                "lookup_descriptor": lookup_descriptor,
                "request_path": str(request_path),
                "registry_source": remote_resolution["registry_source"],
                "remote_status": remote_resolution["status"],
            },
        )
        if remote_resolution["status"] != "resolved":
            return {
                "status": remote_resolution["status"],
                "plan": plan,
                "approval_record": approval_record,
                "lookup_descriptor": lookup_descriptor,
                "request_path": str(request_path),
                "remote_resolution": remote_resolution,
            }
        selected_connector = remote_resolution["matched_connector"]
        connector_strategy = {
            **connector_strategy,
            "selected_connector": selected_connector,
            "status": "resolved",
            "delivery_strategy": {
                **connector_strategy["delivery_strategy"],
                "selected_delivery_language": selected_connector.get(
                    "delivery_languages",
                    [connector_strategy["delivery_strategy"].get("selected_delivery_language")],
                )[0],
                "selected_coupling_mode": selected_connector.get(
                    "coupling_modes",
                    [connector_strategy["delivery_strategy"].get("selected_coupling_mode")],
                )[0],
                "delivery_target": (
                    "target_codebase"
                    if "embedded_target_code" in selected_connector.get("coupling_modes", [])
                    else "documentation"
                ),
                "requires_host_installation": False,
            },
        }

    activation = _activate_connector(
        target=target,
        environment=environment,
        connector=selected_connector,
        delivery_strategy=connector_strategy["delivery_strategy"],
        force_rebuild=force_rebuild,
    )
    return {
        "status": "connector_ready",
        "plan": plan,
        "approval_record": approval_record,
        "activation": activation,
    }

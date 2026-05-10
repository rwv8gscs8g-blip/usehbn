"""Connector resolution for HBN universal translation.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

from typing import Any, Dict, List, Optional

from usehbn.connectors.catalog import built_in_connectors
from usehbn.connectors.trust import evaluate_connector_trust


def _choose_delivery_language(
    connector: Dict[str, Any],
    technology_fingerprint: Dict[str, Any],
) -> Optional[str]:
    available = connector.get("delivery_languages", [])
    preferred = technology_fingerprint.get("preferred_delivery_languages", [])
    for language in preferred:
        if language in available:
            return language
    return available[0] if available else None


def _choose_coupling_mode(
    connector: Dict[str, Any],
    technology_fingerprint: Dict[str, Any],
    *,
    environment: Dict[str, Any],
) -> Optional[str]:
    available = connector.get("coupling_modes", [])
    preferred = technology_fingerprint.get("preferred_coupling_modes", [])
    for mode in preferred:
        if mode in available:
            return mode
    if environment.get("surface") == "runtime_adapter" and "runtime_adapter" in available:
        return "runtime_adapter"
    if environment.get("surface") == "shell" and "bootstrap_wrapper" in available:
        return "bootstrap_wrapper"
    if technology_fingerprint.get("prefer_embedded_delivery") and "embedded_target_code" in available:
        return "embedded_target_code"
    return available[0] if available else None


def _delivery_target_for_mode(coupling_mode: Optional[str]) -> str:
    if coupling_mode == "embedded_target_code":
        return "target_codebase"
    if coupling_mode == "runtime_adapter":
        return "runtime_surface"
    if coupling_mode == "bootstrap_wrapper":
        return "host_environment"
    return "documentation"


def _requires_host_installation(coupling_mode: Optional[str], installation_mode: Optional[str]) -> bool:
    if coupling_mode == "embedded_target_code":
        return False
    return installation_mode in {"bootstrap", "adapter", "bootstrap_or_adapter"}


def _score_connector(
    connector: Dict[str, Any],
    *,
    runtime: Optional[str],
    target_technology: str,
    human_language: str,
) -> int:
    connector_runtimes = connector.get("surface_runtimes", [])
    supported_targets = connector.get("supported_target_technologies", [])
    if runtime:
        if runtime not in connector_runtimes and "*" not in connector_runtimes:
            return 0
    elif connector.get("kind") == "runtime":
        return 0

    if target_technology not in supported_targets and "*" not in supported_targets:
        return 0

    score = 0
    if runtime and runtime in connector_runtimes:
        score += 6
    if "*" in supported_targets:
        score += 2
    if target_technology in supported_targets:
        score += 5
    if "*" in connector.get("supported_human_languages", []):
        score += 1
    if human_language and human_language in connector.get("supported_human_languages", []):
        score += 3
    return score


def resolve_connector_strategy(
    *,
    environment: Dict[str, Any],
    technology_fingerprint: Dict[str, Any],
) -> Dict[str, Any]:
    connectors = built_in_connectors()
    scored: List[Dict[str, Any]] = []
    for connector in connectors:
        score = _score_connector(
            connector,
            runtime=environment.get("runtime"),
            target_technology=technology_fingerprint["target_technology_id"],
            human_language=technology_fingerprint["human_language"],
        )
        if score > 0:
            scored.append({"score": score, "connector": connector})

    scored.sort(key=lambda item: item["score"], reverse=True)
    selected = scored[0]["connector"] if scored else None
    github_lookup_needed = selected is None

    trust_policy = evaluate_connector_trust(
        selected or {
            "source": {
                "trust_level": "unknown",
            },
            "requires_human_approval": True,
        },
        github_lookup_needed=github_lookup_needed,
    )

    if selected:
        selected_language = _choose_delivery_language(selected, technology_fingerprint)
        selected_coupling_mode = _choose_coupling_mode(
            selected,
            technology_fingerprint,
            environment=environment,
        )
        actions = []
        if trust_policy["requires_human_approval"]:
            actions.append("Request explicit human approval before installation or activation.")
        else:
            actions.append("Connector is approved for automatic activation in the current environment.")
        if selected_coupling_mode == "embedded_target_code":
            actions.append("Prefer delivery inside the target technology to reduce installation friction.")
        elif selected_coupling_mode == "runtime_adapter":
            actions.append("Prefer repository-local runtime adapter delivery for the active AI surface.")
        elif selected_coupling_mode == "bootstrap_wrapper":
            actions.append("Prefer a local host bootstrap wrapper for this environment.")

        return {
            "status": "resolved",
            "selected_connector": selected,
            "delivery_strategy": {
                "translator_impl_language": selected.get("translator_impl_language"),
                "delivery_languages": selected.get("delivery_languages", []),
                "selected_delivery_language": selected_language,
                "coupling_modes": selected.get("coupling_modes", []),
                "selected_coupling_mode": selected_coupling_mode,
                "installation_mode": selected.get("installation_mode"),
                "can_embed_in_target": "embedded_target_code" in selected.get("coupling_modes", []),
                "delivery_target": _delivery_target_for_mode(selected_coupling_mode),
                "requires_host_installation": _requires_host_installation(
                    selected_coupling_mode,
                    selected.get("installation_mode"),
                ),
                "avoid_installation_when_possible": technology_fingerprint.get("avoid_installation_when_possible", False),
                "prefer_embedded_delivery": technology_fingerprint.get("prefer_embedded_delivery", False),
                "rationale": [
                    technology_fingerprint.get("delivery_rationale"),
                    f"Selected delivery language: {selected_language or 'unspecified'}.",
                    f"Selected coupling mode: {selected_coupling_mode or 'unspecified'}.",
                ],
            },
            "trust_policy": trust_policy,
            "candidate_connectors": scored,
            "next_actions": actions,
        }

    return {
        "status": "requires_github_lookup",
        "selected_connector": None,
        "delivery_strategy": {
            "translator_impl_language": None,
            "delivery_languages": [],
            "selected_delivery_language": technology_fingerprint.get("preferred_delivery_languages", [None])[0],
            "coupling_modes": [],
            "selected_coupling_mode": technology_fingerprint.get("preferred_coupling_modes", [None])[0],
            "installation_mode": "requires_resolution",
            "can_embed_in_target": False,
            "delivery_target": "unresolved",
            "requires_host_installation": None,
            "avoid_installation_when_possible": technology_fingerprint.get("avoid_installation_when_possible", True),
            "prefer_embedded_delivery": technology_fingerprint.get("prefer_embedded_delivery", False),
            "rationale": [
                technology_fingerprint.get("delivery_rationale"),
                "No approved local connector matched the current runtime and target technology.",
            ],
        },
        "trust_policy": trust_policy,
        "candidate_connectors": scored,
        "requested_connector_descriptor": {
            "surface_runtime_id": technology_fingerprint.get("surface_runtime_id"),
            "host_technology_id": technology_fingerprint.get("host_technology_id"),
            "target_technology_id": technology_fingerprint.get("target_technology_id"),
            "human_language": technology_fingerprint.get("human_language"),
            "preferred_delivery_language": technology_fingerprint.get("preferred_delivery_languages", [None])[0],
            "preferred_coupling_mode": technology_fingerprint.get("preferred_coupling_modes", [None])[0],
        },
        "next_actions": [
            "Request explicit human approval before querying the project registry on GitHub.",
            "Resolve translator bridge by runtime, host technology, target technology, human language, and preferred delivery language.",
        ],
    }

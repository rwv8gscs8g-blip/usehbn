"""Approved and anonymized remote connector lookup helpers.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List, Optional


DEFAULT_REGISTRY_SOURCE = "https://github.com/usehbn/usehbn/tree/main/registry/connectors"


def build_remote_lookup_descriptor(
    *,
    connector_contract: Dict[str, Any],
    connector_strategy: Dict[str, Any],
    environment: Dict[str, Any],
) -> Dict[str, Any]:
    fingerprint = environment.get("technology_fingerprint", {})
    remote_lookup = connector_contract.get("privacy_contract", {}).get("remote_lookup", {})
    allowed_fields = set(remote_lookup.get("allowed_payload_scope", []))
    raw_descriptor = {
        "surface_runtime_id": fingerprint.get("surface_runtime_id"),
        "host_technology_id": fingerprint.get("host_technology_id"),
        "target_technology_id": fingerprint.get("target_technology_id"),
        "human_language_family": fingerprint.get("human_language_family"),
        "preferred_delivery_language": connector_strategy.get("delivery_strategy", {}).get("selected_delivery_language"),
        "preferred_coupling_mode": connector_strategy.get("delivery_strategy", {}).get("selected_coupling_mode"),
    }
    return {
        key: value
        for key, value in raw_descriptor.items()
        if key in allowed_fields and value not in {None, ""}
    }


def _score_registry_connector(connector: Dict[str, Any], descriptor: Dict[str, Any]) -> int:
    runtimes = connector.get("surface_runtimes", [])
    targets = connector.get("supported_target_technologies", [])
    languages = connector.get("supported_human_languages", [])
    delivery_languages = connector.get("delivery_languages", [])
    coupling_modes = connector.get("coupling_modes", [])

    score = 0
    runtime = descriptor.get("surface_runtime_id")
    if runtime:
        if runtime in runtimes:
            score += 5
        elif "*" not in runtimes:
            return 0

    target = descriptor.get("target_technology_id")
    if target:
        if target in targets:
            score += 6
        elif "*" not in targets:
            return 0

    language_family = descriptor.get("human_language_family")
    if language_family and language_family in languages:
        score += 2
    elif "*" in languages:
        score += 1

    preferred_delivery = descriptor.get("preferred_delivery_language")
    if preferred_delivery and preferred_delivery in delivery_languages:
        score += 2

    preferred_coupling = descriptor.get("preferred_coupling_mode")
    if preferred_coupling and preferred_coupling in coupling_modes:
        score += 2

    return score


def resolve_remote_connector_descriptor(
    *,
    lookup_descriptor: Dict[str, Any],
    registry_file: Optional[Path] = None,
) -> Dict[str, Any]:
    if registry_file is None:
        return {
            "status": "awaiting_remote_registry",
            "registry_source": DEFAULT_REGISTRY_SOURCE,
            "matched_connector": None,
        }

    resolved_registry = Path(registry_file).expanduser().resolve()
    if not resolved_registry.exists():
        return {
            "status": "registry_file_missing",
            "registry_source": str(resolved_registry),
            "matched_connector": None,
        }

    payload = json.loads(resolved_registry.read_text(encoding="utf-8"))
    connectors: List[Dict[str, Any]] = payload.get("connectors", [])
    scored: List[Dict[str, Any]] = []
    for connector in connectors:
        score = _score_registry_connector(connector, lookup_descriptor)
        if score > 0:
            scored.append({"score": score, "connector": connector})

    scored.sort(key=lambda item: item["score"], reverse=True)
    matched = scored[0]["connector"] if scored else None
    return {
        "status": "resolved" if matched else "no_match",
        "registry_source": str(resolved_registry),
        "matched_connector": matched,
        "candidates": scored,
    }

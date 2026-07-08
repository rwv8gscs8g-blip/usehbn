"""Universal natural-entry translation for HBN surfaces and runtimes.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any, Dict, Mapping, Optional

from usehbn.connectors import build_connector_operation_contract, resolve_connector_strategy
from usehbn.connectors.profiles import (
    detect_device_profile,
    detect_human_language_profile,
    detect_technology_fingerprint,
)
from usehbn.runtime import detect_runtime_context
from usehbn.trigger import detect_activation


def detect_environment_profile(
    *,
    target: Optional[Path] = None,
    env: Optional[Mapping[str, str]] = None,
    interface_hint: Optional[str] = None,
) -> Dict[str, Any]:
    """Describe the current environment in a machine-usable HBN shape."""
    effective_env = dict(os.environ if env is None else env)
    resolved_target = Path(target).expanduser().resolve() if target else None
    runtime_context = detect_runtime_context(resolved_target) if resolved_target else {
        "runtime": None,
        "signal_type": "none",
        "source": "",
        "candidates": [],
    }

    surface = interface_hint or "shell"
    if runtime_context.get("runtime") in {"codex", "claude-code", "cursor", "copilot", "chatgpt", "gemini", "antigravity"}:
        surface = "runtime_adapter"

    human_language_profile = detect_human_language_profile(effective_env)
    device_profile = detect_device_profile(effective_env)
    technology_fingerprint = detect_technology_fingerprint(
        target=resolved_target,
        surface=surface,
        runtime=runtime_context.get("runtime"),
        device_profile=device_profile,
        human_language_profile=human_language_profile,
    )

    return {
        "surface": surface,
        "runtime": runtime_context.get("runtime"),
        "runtime_signal_type": runtime_context.get("signal_type"),
        "runtime_source": runtime_context.get("source"),
        "target_path": str(resolved_target) if resolved_target else None,
        "has_shell_path_access": bool(effective_env.get("PATH")),
        "candidates": runtime_context.get("candidates", []),
        "human_language_profile": human_language_profile,
        "device_profile": device_profile,
        "technology_fingerprint": technology_fingerprint,
    }


DEFAULT_FALLBACK_LANGUAGE_FAMILY = "en"


def resolve_language_fallback(human_language_profile: Mapping[str, Any]) -> Dict[str, Any]:
    """Deterministic fallback for translation when locale is unknown.

    Returns the effective language family the translator should assume, and a
    boolean indicating whether the value came from a real detection or from
    the deterministic fallback. Pure: no I/O.
    """
    family = (human_language_profile or {}).get("language_family") or "unknown"
    detected = (human_language_profile or {}).get("detected_language") or "unknown"
    is_fallback = family in ("unknown", "") or detected == "unknown"
    return {
        "effective_language_family": DEFAULT_FALLBACK_LANGUAGE_FAMILY if is_fallback else family,
        "is_fallback": is_fallback,
        "source": "deterministic_fallback" if is_fallback else "env_locale",
    }


def translate_natural_entry(
    text: str,
    *,
    target: Optional[Path] = None,
    env: Optional[Mapping[str, str]] = None,
    interface_hint: Optional[str] = None,
) -> Dict[str, Any]:
    """Translate a natural HBN entry into the correct machine path for the environment."""
    activation = detect_activation(text)
    environment = detect_environment_profile(
        target=target,
        env=env,
        interface_hint=interface_hint,
    )
    language_fallback = resolve_language_fallback(environment["human_language_profile"])
    connector_strategy = resolve_connector_strategy(
        environment=environment,
        technology_fingerprint=environment["technology_fingerprint"],
    )
    connector_contract = build_connector_operation_contract(
        environment=environment,
        connector_strategy=connector_strategy,
    )

    if not activation["hbn_activated"]:
        return {
            "status": "inactive",
            "reason": "No HBN semantic anchor detected.",
            "activation": activation,
            "environment": environment,
            "language_fallback": language_fallback,
            "connector_strategy": connector_strategy,
            "connector_contract": connector_contract,
            "recommended_machine_path": None,
        }

    recommended_machine_path = {
        "normalized_trigger": activation["normalized_trigger"],
        "command": f'hbn run "{text}"',
        "shell_alias_command": f'use hbn {text.replace(activation["matched_text"] or "use hbn", "", 1).strip()}',
        "adapter_runtime": environment["runtime"],
        "surface": environment["surface"],
    }

    bootstrap_actions = []
    if environment["surface"] == "shell":
        bootstrap_actions.append("Run ./get-hbn to install local hbn, usehbn, and use wrappers.")
    if target and not environment["runtime"]:
        bootstrap_actions.append("Run hbn init --runtime auto to install the matching runtime adapter.")

    return {
        "status": "translated",
        "activation": activation,
        "environment": environment,
        "language_fallback": language_fallback,
        "recommended_machine_path": recommended_machine_path,
        "bootstrap_actions": bootstrap_actions,
        "connector_strategy": connector_strategy,
        "connector_contract": connector_contract,
    }

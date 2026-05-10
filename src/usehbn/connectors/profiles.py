"""Human, device, and technology profiling for HBN connectors.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

import json
import os
import platform
from pathlib import Path
from typing import Any, Dict, Mapping, Optional


def detect_human_language_profile(env: Optional[Mapping[str, str]] = None) -> Dict[str, Any]:
    effective_env = dict(os.environ if env is None else env)
    locale_value = (
        effective_env.get("HBN_HUMAN_LANGUAGE")
        or effective_env.get("LC_ALL")
        or effective_env.get("LC_MESSAGES")
        or effective_env.get("LANG")
        or ""
    )
    normalized = locale_value.replace("_", "-") if locale_value else "unknown"
    if "." in normalized:
        normalized = normalized.split(".", 1)[0]

    language_family = "unknown"
    if normalized and normalized != "unknown":
        language_family = normalized.split("-", 1)[0].lower()

    return {
        "detected_language": normalized,
        "language_family": language_family,
        "source": "env_locale" if locale_value else "unknown",
        "confidence": 0.8 if locale_value else 0.0,
    }


def detect_device_profile(env: Optional[Mapping[str, str]] = None) -> Dict[str, Any]:
    effective_env = dict(os.environ if env is None else env)
    shell = Path(effective_env.get("SHELL", "")).name or "unknown"
    system = platform.system().lower() or "unknown"
    machine = platform.machine().lower() or "unknown"

    return {
        "os_family": system,
        "shell": shell,
        "machine_arch": machine,
        "device_id": f"{system}-{shell}" if shell != "unknown" else system,
        "supports_shell_wrappers": shell != "unknown",
    }


def _detect_repo_technology(target: Path) -> str:
    package_json = target / "package.json"
    pyproject = target / "pyproject.toml"
    pom_xml = target / "pom.xml"
    gradle = target / "build.gradle"
    gradle_kts = target / "build.gradle.kts"
    if package_json.exists():
        try:
            package = json.loads(package_json.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            package = {}
        dependencies = {
            **package.get("dependencies", {}),
            **package.get("devDependencies", {}),
        }
        if "next" in dependencies and (target / "vercel.json").exists():
            return "nextjs-vercel"
        if "next" in dependencies:
            return "nextjs"
        return "node"
    if pyproject.exists():
        return "python"
    if any(target.glob("*.py")):
        return "python"
    if pom_xml.exists() or gradle.exists() or gradle_kts.exists():
        return "java"
    if any(target.glob("*.java")):
        return "java"
    if any(target.glob("*.xlsm")) or any(target.glob("*.xlsb")):
        return "excel-vba"
    if any(target.glob("*.bas")) or any(target.glob("*.cls")) or any(target.glob("*.frm")):
        return "excel-vba"
    if any(target.glob("*.cbl")) or any(target.glob("*.cob")) or any(target.glob("*.cpy")):
        return "cobol"
    if any(target.glob("*.pas")) or any(target.glob("*.pp")) or any(target.glob("*.dpr")):
        return "pascal"
    if any(target.glob("*.lua")):
        return "lua"
    if any(target.glob("*.swift")):
        return "swift"
    if any(target.glob("*.csproj")) or any(target.glob("*.sln")) or any(target.glob("*.cs")):
        return "csharp"
    if any(target.glob("*.cpp")) or any(target.glob("*.cc")) or any(target.glob("*.cxx")) or any(target.glob("*.hpp")):
        return "cpp"
    if any(target.glob("*.c")) or any(target.glob("*.h")):
        return "c"
    if any(target.glob("*.sh")):
        return "unix-shell"
    return "generic-repository"


def build_technology_preferences(
    *,
    target_technology: str,
    surface: str,
    runtime: Optional[str],
    device_profile: Dict[str, Any],
) -> Dict[str, Any]:
    if target_technology == "excel-vba":
        return {
            "preferred_delivery_languages": ["vba", "bas", "cls", "frm", "markdown"],
            "preferred_coupling_modes": ["embedded_target_code", "documentary_bridge"],
            "avoid_installation_when_possible": True,
            "prefer_embedded_delivery": True,
            "technology_family": "legacy-office",
            "delivery_rationale": "Legacy Office targets work best with embedded bridge artifacts and minimal external installation.",
        }
    if target_technology == "cobol":
        return {
            "preferred_delivery_languages": ["cobol", "copybook", "jcl", "txt", "markdown"],
            "preferred_coupling_modes": ["embedded_target_code", "documentary_bridge"],
            "avoid_installation_when_possible": True,
            "prefer_embedded_delivery": True,
            "technology_family": "legacy-mainframe",
            "delivery_rationale": "COBOL environments are constrained and usually prefer target-native bridge artifacts over host-side installers.",
        }
    if target_technology in {"pascal", "lua", "swift", "cpp", "c", "java", "csharp"}:
        language = {
            "cpp": "c++",
            "csharp": "csharp",
        }.get(target_technology, target_technology)
        return {
            "preferred_delivery_languages": [language, "markdown"],
            "preferred_coupling_modes": ["embedded_target_code", "documentary_bridge"],
            "avoid_installation_when_possible": True,
            "prefer_embedded_delivery": True,
            "technology_family": "native-code",
            "delivery_rationale": "Native-code targets can often accept bridge delivery directly in the destination language to reduce extra installation.",
        }
    if target_technology == "unix-shell":
        shell = device_profile.get("shell") or "sh"
        return {
            "preferred_delivery_languages": [shell, "sh", "markdown"],
            "preferred_coupling_modes": ["embedded_target_code", "bootstrap_wrapper", "documentary_bridge"],
            "avoid_installation_when_possible": True,
            "prefer_embedded_delivery": True,
            "technology_family": "shell",
            "delivery_rationale": "Shell-first environments benefit from direct script delivery before introducing extra installers.",
        }
    if target_technology in {"nextjs-vercel", "nextjs"}:
        return {
            "preferred_delivery_languages": ["typescript", "javascript", "json", "markdown"],
            "preferred_coupling_modes": ["runtime_adapter", "bootstrap_wrapper", "documentary_bridge"],
            "avoid_installation_when_possible": False,
            "prefer_embedded_delivery": False,
            "technology_family": "web-app",
            "delivery_rationale": "Modern web repos usually benefit more from runtime integration and repository-local adapters than from embedded bridge code.",
        }
    if target_technology in {"node", "python"}:
        return {
            "preferred_delivery_languages": [target_technology, "json", "markdown"],
            "preferred_coupling_modes": ["bootstrap_wrapper", "documentary_bridge"],
            "avoid_installation_when_possible": False,
            "prefer_embedded_delivery": False,
            "technology_family": "managed-runtime",
            "delivery_rationale": "Managed runtimes typically support local tooling and bootstrap wrappers safely.",
        }
    if surface == "runtime_adapter" and runtime:
        return {
            "preferred_delivery_languages": ["markdown"],
            "preferred_coupling_modes": ["runtime_adapter", "documentary_bridge"],
            "avoid_installation_when_possible": False,
            "prefer_embedded_delivery": False,
            "technology_family": "runtime-adapter",
            "delivery_rationale": "When an AI runtime is already active, adapter-based delivery is the least invasive bridge.",
        }
    return {
        "preferred_delivery_languages": ["markdown"],
        "preferred_coupling_modes": ["documentary_bridge", "bootstrap_wrapper"],
        "avoid_installation_when_possible": True,
        "prefer_embedded_delivery": False,
        "technology_family": "generic",
        "delivery_rationale": "Unknown targets should start from explicit, low-risk documentary bridges until a stronger translator is approved.",
    }


def detect_technology_fingerprint(
    *,
    target: Optional[Path],
    surface: str,
    runtime: Optional[str],
    device_profile: Dict[str, Any],
    human_language_profile: Dict[str, Any],
) -> Dict[str, Any]:
    resolved_target = Path(target).expanduser().resolve() if target else None
    target_technology = _detect_repo_technology(resolved_target) if resolved_target else "generic-repository"
    preferences = build_technology_preferences(
        target_technology=target_technology,
        surface=surface,
        runtime=runtime,
        device_profile=device_profile,
    )

    return {
        "surface_runtime_id": runtime or surface,
        "host_technology_id": device_profile["device_id"],
        "target_technology_id": target_technology,
        "human_language": human_language_profile["detected_language"],
        "human_language_family": human_language_profile["language_family"],
        "technology_family": preferences["technology_family"],
        "preferred_delivery_languages": preferences["preferred_delivery_languages"],
        "preferred_coupling_modes": preferences["preferred_coupling_modes"],
        "avoid_installation_when_possible": preferences["avoid_installation_when_possible"],
        "prefer_embedded_delivery": preferences["prefer_embedded_delivery"],
        "delivery_rationale": preferences["delivery_rationale"],
    }

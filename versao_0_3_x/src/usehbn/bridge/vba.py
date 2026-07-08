"""Conceptual VBA bridge helpers for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

from typing import Dict, List


BRIDGE_DISCLAIMERS: tuple[str, ...] = (
    "This bridge is a Stub per MATURITY-MATRIX v0.3.0 — no executable VBA is produced.",
    "Output is a documentation scaffold for humans, not a generator of working .bas modules.",
    "Executable bridges per technology are described in docs/PHAGOCYTOSIS.md as a future path.",
)


def list_bridge_disclaimers() -> List[str]:
    """Return the canonical disclaimers about HBN bridge maturity."""
    return list(BRIDGE_DISCLAIMERS)


def describe_vba_bridge(system_name: str, invariants: List[str]) -> Dict[str, object]:
    """Return a conceptual HBN bridge plan for an Excel/VBA system."""
    return {
        "system": system_name,
        "bridge_type": "conceptual_only",
        "maturity": "stub",
        "disclaimers": list_bridge_disclaimers(),
        "invariants": invariants,
        "recommended_checks": [
            "Map workbook modules, forms, and entry points before refactoring.",
            "State business invariants in plain language and keep them versioned.",
            "Require regression scenarios for calculations, exports, and user forms.",
            "Apply HBN truth barrier and guardian checks before release decisions.",
        ],
    }

"""Conceptual VBA bridge helpers for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

from typing import Dict, List


def describe_vba_bridge(system_name: str, invariants: List[str]) -> Dict[str, object]:
    """Return a conceptual HBN bridge plan for an Excel/VBA system."""
    return {
        "system": system_name,
        "bridge_type": "conceptual_only",
        "invariants": invariants,
        "recommended_checks": [
            "Map workbook modules, forms, and entry points before refactoring.",
            "State business invariants in plain language and keep them versioned.",
            "Require regression scenarios for calculations, exports, and user forms.",
            "Apply HBN truth barrier and guardian checks before release decisions.",
        ],
    }

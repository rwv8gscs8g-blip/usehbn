"""Semantic trigger detection for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import re
from typing import Any, Dict

TRIGGER_PATTERN = re.compile(r"\buse\s*hbn\b", re.IGNORECASE)


def detect_activation(text: str) -> Dict[str, Any]:
    """Detect the HBN semantic trigger in free-form text."""
    match = TRIGGER_PATTERN.search(text or "")
    activated = bool(match)

    return {
        "hbn_activated": activated,
        "signal": "usehbn",
        "matched_text": match.group(0) if match else None,
        "normalized_trigger": "usehbn" if activated else None,
        "stage": "intent_capture" if activated else "idle",
        "span": [match.start(), match.end()] if match else None,
    }

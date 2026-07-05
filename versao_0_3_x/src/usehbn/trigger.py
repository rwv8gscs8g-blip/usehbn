"""Semantic trigger detection for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

import re
from typing import Any, Dict, Optional

TRIGGER_PATTERN = re.compile(r"\buse\s*hbn\b", re.IGNORECASE)


def _classify_trigger_origin(matched_text: Optional[str]) -> Optional[str]:
    """Classify how the trigger appeared so downstream surfaces can adapt.

    - 'shorthand_token' — single-token form `usehbn` (no whitespace);
    - 'natural_phrase'  — two-word form `use hbn` (any whitespace between);
    - None when no match.
    """
    if not matched_text:
        return None
    return "shorthand_token" if " " not in matched_text and "\t" not in matched_text else "natural_phrase"


def detect_activation(text: str) -> Dict[str, Any]:
    """Detect the HBN semantic trigger in free-form text."""
    match = TRIGGER_PATTERN.search(text or "")
    activated = bool(match)
    matched_text = match.group(0) if match else None

    return {
        "hbn_activated": activated,
        "signal": "usehbn",
        "matched_text": matched_text,
        "normalized_trigger": "usehbn" if activated else None,
        "stage": "intent_capture" if activated else "idle",
        "span": [match.start(), match.end()] if match else None,
        "trigger_origin": _classify_trigger_origin(matched_text),
    }

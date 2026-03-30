"""Initial truth barrier for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import re
from typing import Any, Dict, List

OVERCONFIDENCE_PATTERN = re.compile(
    r"\b(always|never fails|guaranteed|perfect|certainly|definitely|undeniable|cannot fail)\b",
    re.IGNORECASE,
)
UNSUPPORTED_CLAIM_PATTERN = re.compile(
    r"\b(100%|zero risk|fully secure|provably safe|unbreakable|complete certainty)\b",
    re.IGNORECASE,
)
UNCERTAINTY_PATTERN = re.compile(r"\b(may|might|could|likely|estimate|assume|tentative)\b", re.IGNORECASE)
RISKY_CONTEXT_PATTERN = re.compile(
    r"\b(delete|drop|production|security|billing|authentication|migration|migrate)\b",
    re.IGNORECASE,
)


def _warning(code: str, severity: str, message: str, evidence: str) -> Dict[str, str]:
    return {
        "code": code,
        "severity": severity,
        "message": message,
        "evidence": evidence,
    }


def evaluate_truth_barrier(text: str, intent: Dict[str, Any]) -> Dict[str, Any]:
    """Flag early signals of overclaiming or missing epistemic caution."""
    warnings: List[Dict[str, str]] = []
    objective = intent.get("objective", "")

    for match in OVERCONFIDENCE_PATTERN.finditer(text):
        warnings.append(
            _warning(
                "overconfidence",
                "warning",
                "Input contains language that implies certainty beyond what the scaffold can justify.",
                match.group(0),
            )
        )

    for match in UNSUPPORTED_CLAIM_PATTERN.finditer(text):
        warnings.append(
            _warning(
                "unsupported_claim",
                "warning",
                "Input contains a claim that should be backed by evidence or reduced in strength.",
                match.group(0),
            )
        )

    if RISKY_CONTEXT_PATTERN.search(objective) and not UNCERTAINTY_PATTERN.search(text):
        warnings.append(
            _warning(
                "missing_uncertainty",
                "warning",
                "Risky intent was detected without an explicit uncertainty or assumption statement.",
                objective,
            )
        )

    return {
        "status": "warn" if warnings else "clear",
        "warnings": warnings,
    }

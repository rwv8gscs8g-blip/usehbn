"""Intent structuring for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import re
from typing import Any, Dict, List, Optional

from usehbn.trigger import detect_activation
from usehbn.utils.validators import assert_valid_payload

CONSTRAINT_PATTERN = re.compile(
    r"\b(without|with|must|should|only|avoid|under|within)\b[^,.;]*",
    re.IGNORECASE,
)
VALIDATION_PATTERN = re.compile(
    r"\b(validate|test|verify|confirm|review|check)\b[^,.;]*",
    re.IGNORECASE,
)
EXPLICIT_RISK_PATTERN = re.compile(r"\brisk[s]?\b[^,.;]*", re.IGNORECASE)
CLAUSE_SPLIT_PATTERN = re.compile(r"[;,]|\s+(?:and|but)\s+", re.IGNORECASE)
HIGH_RISK_KEYWORDS = {
    "delete": "Destructive operation may remove data.",
    "drop": "Schema or data removal may be irreversible.",
    "production": "Production-facing action requires controlled validation.",
    "migrate": "Migration work can introduce compatibility regressions.",
    "security": "Security-sensitive work needs explicit validation.",
    "billing": "Billing-affecting work requires auditability.",
    "authentication": "Authentication flows require correctness and rollback planning.",
}


def _normalize_text(text: str) -> str:
    return " ".join(text.strip().split())


def _slice_objective(text: str, activation: Optional[Dict[str, Any]]) -> str:
    active = activation or detect_activation(text)
    if active.get("span"):
        objective = text[active["span"][1] :]
    else:
        objective = text

    objective = objective.strip(" \t\n\r:,-")
    return _normalize_text(objective)


def _extract_clauses(pattern: re.Pattern[str], text: str) -> List[str]:
    clauses = []
    for segment in CLAUSE_SPLIT_PATTERN.split(text):
        normalized_segment = _normalize_text(segment)
        if not normalized_segment:
            continue
        match = pattern.search(normalized_segment)
        if not match:
            continue
        clause = _normalize_text(match.group(0))
        if clause and clause not in clauses:
            clauses.append(clause)
    return clauses


def _infer_risks(text: str) -> List[str]:
    risks = _extract_clauses(EXPLICIT_RISK_PATTERN, text)
    lowered = text.lower()
    for keyword, description in HIGH_RISK_KEYWORDS.items():
        if keyword in lowered and description not in risks:
            risks.append(description)
    return risks


def structure_intent(text: str, activation: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """Extract a minimal structured intent from free-form input."""
    objective = _slice_objective(text, activation)
    intent = {
        "objective": objective or "No objective supplied after HBN activation.",
        "constraints": _extract_clauses(CONSTRAINT_PATTERN, objective),
        "risks": _infer_risks(objective),
        "validation_requirements": _extract_clauses(VALIDATION_PATTERN, objective),
    }
    assert_valid_payload(intent, "intent.schema.json")
    return intent

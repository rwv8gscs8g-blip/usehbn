"""Initial guardian scaffold for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

from pathlib import Path
from typing import Any, Dict, List, Optional

from usehbn.utils.config import default_state_dir
from usehbn.utils.logger import append_jsonl_log
from usehbn.utils.validators import assert_valid_payload


def assess_guardian(
    intent: Dict[str, Any],
    truth_warnings: List[Dict[str, Any]],
    storage_dir: Optional[Path] = None,
) -> Dict[str, Any]:
    """Monitor missing validations and risky outputs, then log warnings locally."""
    warnings: List[Dict[str, str]] = []

    if intent.get("risks") and not intent.get("validation_requirements"):
        warnings.append(
            {
                "code": "missing_validation",
                "severity": "warning",
                "message": "Risky intent is missing explicit validation requirements.",
            }
        )

    if intent.get("risks"):
        warnings.append(
            {
                "code": "risky_output",
                "severity": "warning",
                "message": "Intent includes risk-sensitive work and should remain under review.",
            }
        )

    warnings.extend(truth_warnings)

    log_path = None
    if warnings:
        log_path = default_state_dir(storage_dir) / "logs" / "guardian.jsonl"
        for item in warnings:
            append_jsonl_log(
                log_path,
                {
                    "event": "guardian_warning",
                    "intent_objective": intent.get("objective"),
                    "warning": item,
                },
            )

    guardian_report = {
        "status": "warn" if warnings else "clear",
        "warnings": warnings,
        "log_path": str(log_path) if log_path else "",
    }
    assert_valid_payload(guardian_report, "guardian.schema.json")
    return guardian_report

"""Trust policy for HBN connector installation and activation.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

from typing import Any, Dict


def evaluate_connector_trust(connector: Dict[str, Any], *, github_lookup_needed: bool) -> Dict[str, Any]:
    source = connector.get("source", {})
    trust_level = source.get("trust_level", "unknown")
    explicit_approval = bool(connector.get("requires_human_approval"))

    requires_approval = explicit_approval or trust_level not in {"approved", "first_party"} or github_lookup_needed
    activation_mode = "manual_approval" if requires_approval else "auto"

    reasons = []
    if explicit_approval:
        reasons.append("Connector policy marks this bridge as human-approved only.")
    if trust_level not in {"approved", "first_party"}:
        reasons.append("Connector source is not yet approved for automatic activation.")
    if github_lookup_needed:
        reasons.append("No approved local connector matched; GitHub lookup requires human authorization.")

    return {
        "trust_level": trust_level,
        "requires_human_approval": requires_approval,
        "activation_mode": activation_mode,
        "approval_reasons": reasons,
    }

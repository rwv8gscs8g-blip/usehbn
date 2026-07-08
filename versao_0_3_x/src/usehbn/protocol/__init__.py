"""Protocol primitives for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from typing import Any, Dict

from usehbn.protocol.consent import create_consent_record
from usehbn.protocol.guardian import assess_guardian
from usehbn.protocol.intent import structure_intent
from usehbn.protocol.truth_barrier import evaluate_truth_barrier


PROTOCOL_LAYERS = (
    "activation",
    "intent",
    "consent",
    "truth_barrier",
    "guardian",
)


def get_protocol_invariant() -> Dict[str, Any]:
    """Canonical, read-only snapshot of HBN protocol invariants."""
    from usehbn import PROTOCOL_VERSION

    return {
        "protocol_version": PROTOCOL_VERSION,
        "layers": list(PROTOCOL_LAYERS),
        "records_require_protocol_version": True,
        "advisory_layers": ("truth_barrier", "guardian"),
    }


__all__ = [
    "PROTOCOL_LAYERS",
    "assess_guardian",
    "create_consent_record",
    "evaluate_truth_barrier",
    "get_protocol_invariant",
    "structure_intent",
]

"""HBN — Human Brain Net.

Copyright 2026 Luis Mauricio Junqueira Zanin

Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

__version__ = "0.3.0"
PACKAGE_VERSION = __version__
PROTOCOL_VERSION = "0.3.0"

from usehbn.protocol.consent import CONSENT_QUESTION, create_consent_record
from usehbn.protocol.guardian import assess_guardian
from usehbn.protocol.intent import structure_intent
from usehbn.protocol.truth_barrier import evaluate_truth_barrier
from usehbn.trigger import detect_activation

__all__ = [
    "CONSENT_QUESTION",
    "PACKAGE_VERSION",
    "PROTOCOL_VERSION",
    "__version__",
    "assess_guardian",
    "create_consent_record",
    "detect_activation",
    "evaluate_truth_barrier",
    "structure_intent",
]

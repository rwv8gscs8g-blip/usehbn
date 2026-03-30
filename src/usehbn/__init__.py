"""HBN — Human Brain Net.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
"""

from usehbn.protocol.consent import CONSENT_QUESTION, create_consent_record
from usehbn.protocol.guardian import assess_guardian
from usehbn.protocol.intent import structure_intent
from usehbn.protocol.truth_barrier import evaluate_truth_barrier
from usehbn.trigger import detect_activation

__all__ = [
    "CONSENT_QUESTION",
    "assess_guardian",
    "create_consent_record",
    "detect_activation",
    "evaluate_truth_barrier",
    "structure_intent",
]

__version__ = "0.2.0"

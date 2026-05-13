"""Canonical HBN signal registry.

The 16 visible HBN status markers (ADR-006 ACCEPTED) are also embedded as
strings in the adapter body of `runtime._adapter_body`. This module is the
machine-readable single source of truth — keep both in sync when adding
signals.

Cycle 2026-05-13 (autoevolve / iter 11) adds `AUTOEVOLVE_TICK` as the 17th
signal, emitted by every microdelta result sealed by `autoevolve.audit`.
"""

from __future__ import annotations

from typing import Tuple


# 10 single-repo signals (ADR-006)
SINGLE_REPO_SIGNALS: Tuple[str, ...] = (
    "HBN_ACTIVE",
    "HBN_SECURITY_BLOCKED_SUGGESTION",
    "HBN_NEEDS_HUMAN_DECISION",
    "HBN_HANDOFF_READY",
    "HBN_PEER_REVIEW",
    "HBN_AUDIT_ONLY",
    "HBN_SOURCE_DRIFT",
    "HBN_RELEASE_BLOCKER",
    "HBN_CHECKPOINT_CLEAN",
    "HBN_LICENSE_SPLIT_REQUIRED",
)

# 6 multi-repo signals (ADR-006)
MULTI_REPO_SIGNALS: Tuple[str, ...] = (
    "HBN_CROSS_REPO_LOCK",
    "HBN_PROTOCOL_DEP_CHANGE",
    "HBN_APP_FROZEN",
    "HBN_MIRROR_DRIFT",
    "HBN_BILLING_WINDOW_DRIFT",
    "HBN_GROUPTHINK_ALARM",
)

# Operational signals — emitted by internal cycles, not user-facing status.
OPERATIONAL_SIGNALS: Tuple[str, ...] = (
    "AUTOEVOLVE_TICK",
)


def all_signals() -> Tuple[str, ...]:
    """Return every canonical HBN signal, in declaration order."""
    return SINGLE_REPO_SIGNALS + MULTI_REPO_SIGNALS + OPERATIONAL_SIGNALS


def is_canonical_signal(name: str) -> bool:
    """Cheap membership check used by audit writers and validators."""
    return name in all_signals()

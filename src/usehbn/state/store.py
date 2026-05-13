"""JSON-backed persistence for HBN execution state.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List, Optional

from usehbn.utils.config import default_state_dir, persistence_dir
from usehbn.utils.logger import write_json

STATE_FILENAME = "hbn-state.json"


def _empty_state() -> Dict[str, Any]:
    return {
        "executions": [],
        "decisions": [],
        "context_history": [],
        "results": [],
    }


def state_file_path(base_dir: Optional[Path] = None) -> Path:
    """Canonical state file path: `.usehbn/hbn-state.json` (Onda 5).

    Pre-Onda-5, this returned `state/hbn-state.json`. Writes now go
    exclusively to `.usehbn/` per the wave plan; reads still fall back
    to the legacy `state/` location via `_legacy_state_file_path` for
    backward compatibility (see `load_state_document`).
    """
    return default_state_dir(base_dir) / STATE_FILENAME


def _legacy_state_file_path(base_dir: Optional[Path] = None) -> Path:
    """Pre-Onda-5 location: `state/hbn-state.json`. Read-only fallback."""
    return persistence_dir(base_dir) / STATE_FILENAME


def _read_json_or_empty(path: Path) -> Dict[str, Any]:
    if not path.exists():
        return _empty_state()
    document = json.loads(path.read_text(encoding="utf-8"))
    empty_state = _empty_state()
    for key, default_value in empty_state.items():
        document.setdefault(key, default_value.copy())
    return document


def load_state_document(base_dir: Optional[Path] = None) -> Dict[str, Any]:
    """Onda 5 dual-read: prefer `.usehbn/`, fall back to legacy `state/`.

    If both exist, merge `results` and `executions` deduplicating by
    `traceability.execution_id` (preferring entries from `.usehbn/`).
    Other arrays (`decisions`, `context_history`) are concatenated with
    `.usehbn/` first to keep newer entries at the head when iterating.
    """
    canonical = state_file_path(base_dir)
    legacy = _legacy_state_file_path(base_dir)

    if not canonical.exists() and not legacy.exists():
        return _empty_state()
    if not legacy.exists():
        return _read_json_or_empty(canonical)
    if not canonical.exists():
        return _read_json_or_empty(legacy)

    # Both exist — merge with dedup.
    canonical_doc = _read_json_or_empty(canonical)
    legacy_doc = _read_json_or_empty(legacy)

    def _merged_with_dedup(canonical_list: list, legacy_list: list) -> list:
        seen_ids = set()
        out = []
        for item in canonical_list:
            exec_id = (item or {}).get("traceability", {}).get("execution_id")
            if exec_id is not None:
                seen_ids.add(exec_id)
            out.append(item)
        for item in legacy_list:
            exec_id = (item or {}).get("traceability", {}).get("execution_id")
            if exec_id is not None and exec_id in seen_ids:
                continue
            out.append(item)
        return out

    return {
        "executions": _merged_with_dedup(canonical_doc["executions"], legacy_doc["executions"]),
        "decisions": canonical_doc["decisions"] + legacy_doc["decisions"],
        "context_history": canonical_doc["context_history"] + legacy_doc["context_history"],
        "results": _merged_with_dedup(canonical_doc["results"], legacy_doc["results"]),
    }


def summarize_state_document(document: Dict[str, Any]) -> Dict[str, Any]:
    """Aggregate counts for the four canonical state arrays — pure, no I/O.

    Useful for `hbn doctor`, the autoevolve audit report, and any UI surface
    that wants a fast health snapshot without parsing the whole document.
    """
    empty = _empty_state()
    out: Dict[str, Any] = {}
    for key in empty:
        value = document.get(key) if isinstance(document, dict) else None
        out[key] = len(value) if isinstance(value, list) else 0
    out["total_records"] = sum(out.values())
    return out


def append_execution_state(
    execution: Dict[str, Any],
    decisions: List[Dict[str, Any]],
    context_entry: Dict[str, Any],
    base_dir: Optional[Path] = None,
) -> Path:
    document = load_state_document(base_dir)
    document["executions"].append(execution)
    document["decisions"].extend(decisions)
    document["context_history"].append(context_entry)

    path = state_file_path(base_dir)
    write_json(path, document)
    return path


def append_result_state(result_record: Dict[str, Any], base_dir: Optional[Path] = None) -> Path:
    document = load_state_document(base_dir)
    execution_id = result_record["traceability"]["execution_id"]
    existing_ids = {
        item.get("traceability", {}).get("execution_id")
        for item in document["results"]
    }
    if execution_id in existing_ids:
        raise ValueError(f"Result state already contains execution_id: {execution_id}")
    document["results"].append(result_record)

    path = state_file_path(base_dir)
    write_json(path, document)
    return path

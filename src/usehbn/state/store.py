"""JSON-backed persistence for HBN execution state.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List, Optional

from usehbn.utils.config import LEGACY_STATE_DIRNAME, STATE_DIRNAME
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
    """Canonical state file path: `.hbn/state/hbn-state.json`.

    R1 consolidates runtime state under `.hbn/` while preserving read-only
    fallbacks for the older `.usehbn/hbn-state.json` and `state/hbn-state.json`
    locations.
    """
    return _root(base_dir) / STATE_DIRNAME / "state" / STATE_FILENAME


def _root(base_dir: Optional[Path] = None) -> Path:
    return base_dir if base_dir is not None else Path.cwd()


def _legacy_usehbn_state_file_path(base_dir: Optional[Path] = None) -> Path:
    """Pre-R1 location: `.usehbn/hbn-state.json`. Read-only fallback."""
    return _root(base_dir) / LEGACY_STATE_DIRNAME / STATE_FILENAME


def _legacy_state_file_path(base_dir: Optional[Path] = None) -> Path:
    """Pre-Onda-5 location: `state/hbn-state.json`. Read-only fallback."""
    return _root(base_dir) / "state" / STATE_FILENAME


def _read_json_or_empty(path: Path) -> Dict[str, Any]:
    if not path.exists():
        return _empty_state()
    document = json.loads(path.read_text(encoding="utf-8"))
    empty_state = _empty_state()
    for key, default_value in empty_state.items():
        document.setdefault(key, default_value.copy())
    return document


def load_state_document(base_dir: Optional[Path] = None) -> Dict[str, Any]:
    """Load canonical `.hbn/state/` plus read-only legacy state files.

    If multiple files exist, merge arrays deduplicating by execution identity
    when present, otherwise by deterministic item content, and preferring
    canonical `.hbn/state/`, then `.usehbn/`, then legacy `state/`.
    """
    paths = [
        state_file_path(base_dir),
        _legacy_usehbn_state_file_path(base_dir),
        _legacy_state_file_path(base_dir),
    ]
    existing_paths = [path for path in paths if path.exists()]

    if not existing_paths:
        return _empty_state()
    if len(existing_paths) == 1:
        return _read_json_or_empty(existing_paths[0])

    documents = [_read_json_or_empty(path) for path in existing_paths]

    def _record_execution_id(item: Any) -> Optional[str]:
        if not isinstance(item, dict):
            return None
        traceability = item.get("traceability")
        traceability_id = (
            traceability.get("execution_id")
            if isinstance(traceability, dict)
            else None
        )
        return traceability_id or item.get("execution_id")

    def _record_identity(item: Any) -> tuple[str, str]:
        exec_id = _record_execution_id(item)
        if exec_id is not None:
            return ("execution_id", str(exec_id))
        return (
            "content",
            json.dumps(item, sort_keys=True, separators=(",", ":"), ensure_ascii=False),
        )

    def _merged_with_dedup(key: str) -> list:
        seen_identities = set()
        out = []
        for document in documents:
            for item in document[key]:
                identity = _record_identity(item)
                if identity in seen_identities:
                    continue
                seen_identities.add(identity)
                out.append(item)
        return out

    return {
        "executions": _merged_with_dedup("executions"),
        "decisions": _merged_with_dedup("decisions"),
        "context_history": _merged_with_dedup("context_history"),
        "results": _merged_with_dedup("results"),
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

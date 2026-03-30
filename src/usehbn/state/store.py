"""JSON-backed persistence for HBN execution state.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List, Optional

from usehbn.utils.config import persistence_dir
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
    return persistence_dir(base_dir) / STATE_FILENAME


def load_state_document(base_dir: Optional[Path] = None) -> Dict[str, Any]:
    path = state_file_path(base_dir)
    if not path.exists():
        return _empty_state()

    document = json.loads(path.read_text(encoding="utf-8"))
    empty_state = _empty_state()
    for key, default_value in empty_state.items():
        document.setdefault(key, default_value.copy())
    return document


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

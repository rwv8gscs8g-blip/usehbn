"""Configuration utilities for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

from pathlib import Path
from typing import Optional

STATE_DIRNAME = ".usehbn"
LOGS_DIRNAME = "logs"
PERSISTENCE_DIRNAME = "state"


def project_root() -> Path:
    return Path(__file__).resolve().parents[3]


def schemas_dir() -> Path:
    return project_root() / "schemas"


def default_state_dir(base_dir: Optional[Path] = None) -> Path:
    root = base_dir if base_dir is not None else Path.cwd()
    state_dir = root / STATE_DIRNAME
    state_dir.mkdir(parents=True, exist_ok=True)
    return state_dir


def logs_dir(base_dir: Optional[Path] = None) -> Path:
    root = base_dir if base_dir is not None else Path.cwd()
    log_dir = root / LOGS_DIRNAME
    log_dir.mkdir(parents=True, exist_ok=True)
    return log_dir


def persistence_dir(base_dir: Optional[Path] = None) -> Path:
    root = base_dir if base_dir is not None else Path.cwd()
    state_dir = root / PERSISTENCE_DIRNAME
    state_dir.mkdir(parents=True, exist_ok=True)
    return state_dir

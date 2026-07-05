"""File-backed task queue.

Trivial today (one JSONL file). Swappable interface so a future RemoteQueue
(Redis stream, SQS, HTTP) can drop in without touching orchestrator.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Iterator, List

from usehbn.autoevolve.contract import MicrodeltaTask


class FileQueue:
    def __init__(self, path: Path):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)

    def push(self, task: MicrodeltaTask) -> None:
        with self.path.open("a", encoding="utf-8") as fh:
            fh.write(task.to_json() + "\n")

    def push_many(self, tasks: List[MicrodeltaTask]) -> None:
        for task in tasks:
            self.push(task)

    def drain(self) -> Iterator[MicrodeltaTask]:
        if not self.path.exists():
            return
        with self.path.open("r", encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if not line:
                    continue
                yield MicrodeltaTask.from_dict(json.loads(line))

    def __len__(self) -> int:
        if not self.path.exists():
            return 0
        with self.path.open("r", encoding="utf-8") as fh:
            return sum(1 for line in fh if line.strip())

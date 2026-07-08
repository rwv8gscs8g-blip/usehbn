"""Orchestrator — single-machine today, distributed-ready interface.

It pulls tasks from a queue, hands each to a worker, gates approval, writes
audit. The actual code edits for a microdelta are produced by the assistant
(Opus) in the main loop; this orchestrator is the *scaffold* that the future
distributed pool will plug into without API changes.
"""

from __future__ import annotations

from pathlib import Path
from typing import List

from usehbn.autoevolve.approval import approve
from usehbn.autoevolve.audit import AuditWriter
from usehbn.autoevolve.contract import MicrodeltaResult, MicrodeltaTask
from usehbn.autoevolve.queue import FileQueue
from usehbn.autoevolve.worker import LocalWorker


class Orchestrator:
    def __init__(self, queue: FileQueue, worker: LocalWorker, audit: AuditWriter):
        self.queue = queue
        self.worker = worker
        self.audit = audit

    def plan(self, tasks: List[MicrodeltaTask]) -> int:
        self.queue.push_many(tasks)
        return len(tasks)

    def record(self, task: MicrodeltaTask, result: MicrodeltaResult) -> bool:
        approved = approve(task, result, repo_root=self.worker.repo_root)
        if approved and result.status == "ok":
            self.audit.record(result)
        elif not approved:
            result.status = "skipped"
            result.notes = (result.notes + " | gate denied").strip(" |")
            self.audit.record(result)
        else:
            self.audit.record(result)
        return approved

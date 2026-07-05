"""Tests for the autoevolve orchestrator scaffold."""

from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.autoevolve.approval import HUMAN_GATE_FILE, approve, human_gate_active
from usehbn.autoevolve.audit import AuditWriter, CYCLE_SIGNALS, audit_path_for_cycle
from usehbn.autoevolve.contract import CONTRACT_VERSION, MicrodeltaResult, MicrodeltaTask
from usehbn.autoevolve.orchestrator import Orchestrator
from usehbn.autoevolve.queue import FileQueue
from usehbn.autoevolve.worker import LocalWorker


def test_task_roundtrip():
    t = MicrodeltaTask(
        arm="translation",
        slug="fallback",
        spec="docs/spec.md",
        files_allowed=["src/usehbn/translation/", "tests/"],
        tests_required=["tests/test_translation.py"],
    )
    data = json.loads(t.to_json())
    assert data["arm"] == "translation"
    assert data["contract_version"] == CONTRACT_VERSION
    again = MicrodeltaTask.from_dict(data)
    assert again.slug == "fallback"


def test_file_queue_push_drain(tmp_path: Path):
    q = FileQueue(tmp_path / "queue.jsonl")
    q.push(MicrodeltaTask(arm="a", slug="s1", spec="x", files_allowed=["src/"]))
    q.push(MicrodeltaTask(arm="b", slug="s2", spec="x", files_allowed=["src/"]))
    assert len(q) == 2
    arms = [t.arm for t in q.drain()]
    assert arms == ["a", "b"]


def test_worker_scope_validation(tmp_path: Path):
    w = LocalWorker(repo_root=tmp_path)
    task = MicrodeltaTask(arm="x", slug="s", spec="x", files_allowed=["src/usehbn/translation/"])
    ok, _ = w.validate_scope(task, ["src/usehbn/translation/universal.py"])
    assert ok is True
    bad, reason = w.validate_scope(task, ["src/usehbn/cli.py"])
    assert bad is False
    assert "outside" in reason


def test_audit_writer_records_and_seals(tmp_path: Path):
    path = audit_path_for_cycle("2026-05-13", root=tmp_path)
    audit = AuditWriter(path)
    audit.record(MicrodeltaResult(task_id="t1", arm="a", slug="s", status="ok", tests_passed=True))
    rows = audit.read_all()
    assert len(rows) == 1
    assert rows[0]["arm"] == "a"
    assert "AUTOEVOLVE_TICK" in rows[0]["signals"]
    for canonical in CYCLE_SIGNALS:
        assert canonical in rows[0]["signals"]


def test_approve_passes_when_tests_green_and_diff_small():
    task = MicrodeltaTask(arm="x", slug="s", spec="x", files_allowed=["src/"], max_diff_lines=80)
    result = MicrodeltaResult(
        task_id="t1", arm="x", slug="s", status="ok", tests_passed=True, diff_added=10, diff_removed=5
    )
    assert approve(task, result) is True


def test_approve_blocks_on_oversized_diff():
    task = MicrodeltaTask(arm="x", slug="s", spec="x", files_allowed=["src/"], max_diff_lines=20)
    result = MicrodeltaResult(
        task_id="t1", arm="x", slug="s", status="ok", tests_passed=True, diff_added=30, diff_removed=0
    )
    assert approve(task, result) is False


def test_approve_blocks_on_test_failure():
    task = MicrodeltaTask(arm="x", slug="s", spec="x", files_allowed=["src/"])
    result = MicrodeltaResult(task_id="t1", arm="x", slug="s", status="failed", tests_passed=False)
    assert approve(task, result) is False


def test_human_gate_blocks_auto(tmp_path: Path, monkeypatch):
    gate = tmp_path / HUMAN_GATE_FILE
    gate.parent.mkdir(parents=True, exist_ok=True)
    gate.write_text("locked\n")
    monkeypatch.chdir(tmp_path)
    assert human_gate_active() is True
    task = MicrodeltaTask(arm="x", slug="s", spec="x", files_allowed=["src/"], approval="auto")
    result = MicrodeltaResult(task_id="t1", arm="x", slug="s", status="ok", tests_passed=True)
    assert approve(task, result) is False


def test_orchestrator_plan_and_record(tmp_path: Path):
    q = FileQueue(tmp_path / "queue.jsonl")
    w = LocalWorker(repo_root=tmp_path)
    audit_path = audit_path_for_cycle("test", root=tmp_path)
    audit = AuditWriter(audit_path)
    orch = Orchestrator(q, w, audit)
    tasks = [
        MicrodeltaTask(arm="a", slug="s1", spec="x", files_allowed=["src/"]),
        MicrodeltaTask(arm="b", slug="s2", spec="x", files_allowed=["src/"]),
    ]
    assert orch.plan(tasks) == 2
    res = MicrodeltaResult(task_id="t", arm="a", slug="s1", status="ok", tests_passed=True)
    assert orch.record(tasks[0], res) is True
    assert len(audit.read_all()) == 1


def test_cli_status_and_audit(tmp_path: Path, monkeypatch, capsys):
    monkeypatch.chdir(tmp_path)
    path = audit_path_for_cycle("demo")
    AuditWriter(path).record(
        MicrodeltaResult(task_id="t1", arm="x", slug="s", status="ok", tests_passed=True, commit="abcdef1234")
    )
    from usehbn.autoevolve.cli import main as autoevolve_main

    rc = autoevolve_main(["status", "--cycle", "demo"])
    assert rc == 0
    captured = capsys.readouterr().out
    assert "demo" in captured
    rc = autoevolve_main(["audit", "--cycle", "demo"])
    assert rc == 0
    md = capsys.readouterr().out
    assert "Autoevolve cycle audit" in md
    assert "abcdef1234"[:10] in md

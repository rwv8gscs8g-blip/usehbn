"""Tests for HBN relay enforcement, handoff, refresh, and new CLI features.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the Apache License, Version 2.0 (the "License"); see LICENSE for details.
"""

import json
import os
import tempfile
from pathlib import Path

from usehbn.cli import (
    build_root_parser,
    run_doctor,
    run_handoff,
    run_hearback_protocol,
    run_init,
    run_quickstart,
    run_readback_protocol,
    run_refresh,
    run_relay_status,
    run_result_protocol,
)
from usehbn.runtime import (
    detect_runtime_from_env,
    install_runtime_adapter,
    refresh_all_adapters,
)


def _parse_args(argv):
    parser = build_root_parser()
    return parser.parse_args(argv)


def test_detect_runtime_from_env_codex_sandbox():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        os.environ["CODEX_SANDBOX"] = "1"
        try:
            result = detect_runtime_from_env(target)
            assert result == "codex"
        finally:
            del os.environ["CODEX_SANDBOX"]


def test_detect_runtime_from_env_prefers_target_signal_over_host_env():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".claude").mkdir()
        os.environ["CODEX_SANDBOX"] = "1"
        try:
            result = detect_runtime_from_env(target)
            assert result == "claude-code"
        finally:
            del os.environ["CODEX_SANDBOX"]


def test_detect_runtime_from_env_claude():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".claude").mkdir()
        result = detect_runtime_from_env(target)
        assert result == "claude-code"


def test_detect_runtime_from_env_cursor():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".cursor").mkdir()
        result = detect_runtime_from_env(target)
        assert result == "cursor"


def test_detect_runtime_from_env_copilot():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".github").mkdir()
        result = detect_runtime_from_env(target)
        assert result == "copilot"


def test_detect_runtime_from_env_chatgpt():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".chatgpt").mkdir()
        result = detect_runtime_from_env(target)
        assert result == "chatgpt"


def test_detect_runtime_from_env_gemini():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".gemini").mkdir()
        result = detect_runtime_from_env(target)
        assert result == "gemini"


def test_detect_runtime_from_env_antigravity():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".antigravity").mkdir()
        result = detect_runtime_from_env(target)
        assert result == "antigravity"


def test_detect_runtime_from_env_none():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        result = detect_runtime_from_env(target)
        assert result is None


def test_hbn_init_with_runtime_auto():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".github").mkdir()
        args = _parse_args(["init", "--target", str(target), "--runtime", "auto"])
        result = run_init(args)
        assert result["status"] == "initialized"
        assert "adapter_installed" in result
        assert result["adapter_installed"]["runtime"] == "copilot"
        assert result["runtime_detection"]["runtime"] == "copilot"


def test_hbn_init_with_explicit_runtime():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        args = _parse_args(["init", "--target", str(target), "--runtime", "codex"])
        result = run_init(args)
        assert result["status"] == "initialized"
        assert "adapter_installed" in result
        assert result["adapter_installed"]["runtime"] == "codex"


def test_hbn_init_gitignore_suggestions():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".gitignore").write_text("*.pyc\n", encoding="utf-8")
        args = _parse_args(["init", "--target", str(target)])
        result = run_init(args)
        assert result["status"] == "initialized"
        assert ".hbn/readbacks/" in result.get("gitignore_suggestions", [])
        assert ".hbn/results/" in result.get("gitignore_suggestions", [])


def test_hbn_init_no_gitignore_suggestions_when_already_present():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        (target / ".gitignore").write_text(
            ".hbn/readbacks/\n.hbn/results/\n", encoding="utf-8"
        )
        args = _parse_args(["init", "--target", str(target)])
        result = run_init(args)
        # No suggestions needed if already in .gitignore
        assert "gitignore_suggestions" not in result or result["gitignore_suggestions"] == []


def test_relay_status_on_uninitialized_target():
    with tempfile.TemporaryDirectory() as td:
        args = _parse_args(["relay", "status", "--target", str(td)])
        result = run_relay_status(args)
        assert result["relay_status"]["baton_owner"] == "unknown"


def test_relay_status_on_initialized_target():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        init_args = _parse_args(["init", "--target", str(target)])
        run_init(init_args)
        args = _parse_args(["relay", "status", "--target", str(target)])
        result = run_relay_status(args)
        assert result["relay_status"]["baton_owner"] == "unknown"
        assert result["relay_status"]["active_iterations"] == []


def test_handoff_updates_relay_state():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        init_args = _parse_args(["init", "--target", str(target)])
        run_init(init_args)

        args = _parse_args([
            "handoff", "--to", "codex", "--summary", "Initial handoff", "--target", str(target)
        ])
        result = run_handoff(args)
        assert result["handoff"]["to"] == "codex"
        assert result["handoff"]["summary"] == "Initial handoff"

        # Verify state.json was created
        state_path = target / ".hbn" / "relay" / "state.json"
        assert state_path.exists()
        state = json.loads(state_path.read_text(encoding="utf-8"))
        assert state["baton_owner"] == "codex"


def test_handoff_blocks_on_pending_readbacks():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        init_args = _parse_args(["init", "--target", str(target)])
        run_init(init_args)

        # Create a pending readback directly in .hbn/readbacks/
        readbacks_dir = target / ".hbn" / "readbacks"
        readbacks_dir.mkdir(parents=True, exist_ok=True)
        pending_readback = {
            "readback_id": "readback-exec-test",
            "execution_id": "exec-test",
            "agent_id": "codex",
            "track": "safe_track",
            "hearback_status": "pending",
            "understanding": "Test understanding",
            "invariants_preserved": ["test"],
            "action_plan": ["test step"],
            "classification_basis": {
                "has_guardian_warnings": False,
                "has_risks": True,
                "has_constraints": False,
            },
            "created_at": "2026-03-30T00:00:00Z",
        }
        (readbacks_dir / "exec-test.json").write_text(
            json.dumps(pending_readback), encoding="utf-8"
        )

        args = _parse_args([
            "handoff", "--to", "claude", "--summary", "Should fail", "--target", str(target)
        ])
        result = run_handoff(args)
        assert "error" in result
        assert "pending readbacks" in result["error"]


def test_handoff_archives_relay_files():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        init_args = _parse_args(["init", "--target", str(target)])
        run_init(init_args)

        # Create an active relay file
        relay_dir = target / ".hbn" / "relay"
        (relay_dir / "0001-Test.md").write_text("# Test iteration", encoding="utf-8")

        args = _parse_args([
            "handoff", "--to", "human", "--summary", "Done", "--target", str(target)
        ])
        result = run_handoff(args)
        assert "0001-Test.md" in result["handoff"]["archived_files"]

        # Verify file was moved
        assert not (relay_dir / "0001-Test.md").exists()
        archive_dir = target / ".hbn" / "relay-archive"
        archived = list(archive_dir.glob("*Test.md"))
        assert len(archived) == 1


def test_refresh_all_adapters():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        # Install two adapters
        install_runtime_adapter("codex", target, force=False)
        install_runtime_adapter("copilot", target, force=False)

        results = refresh_all_adapters(target)
        assert len(results) == 2
        runtimes = {r["runtime"] for r in results}
        assert "codex" in runtimes
        assert "copilot" in runtimes


def test_refresh_cli_command():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        install_runtime_adapter("codex", target, force=False)

        args = _parse_args(["refresh", "--target", str(target)])
        result = run_refresh(args)
        assert len(result["refreshed_adapters"]) == 1


def test_adapter_body_contains_fallback_section():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        install_runtime_adapter("codex", target, force=False)
        adapter_path = target / "skills" / "hbn" / "SKILL.md"
        content = adapter_path.read_text(encoding="utf-8")
        assert "Fallback: If `hbn` CLI is not available" in content
        assert "readback JSON" in content


def test_doctor_reports_uninitialized_target():
    with tempfile.TemporaryDirectory() as td:
        args = _parse_args(["doctor", "--target", str(td)])
        result = run_doctor(args)
        assert result["doctor"]["status"] == "needs_setup"
        assert result["doctor"]["warnings"] == ["Target is not initialized for HBN yet."]
        assert result["doctor"]["next_steps"][0].startswith("hbn init --target")


def test_doctor_recommends_runtime_install_when_detected_but_missing():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td).resolve()
        (target / ".claude").mkdir()
        run_init(_parse_args(["init", "--target", str(target)]))
        result = run_doctor(_parse_args(["doctor", "--target", str(target)]))
        assert result["doctor"]["status"] == "attention_needed"
        assert result["doctor"]["runtime_detection"]["runtime"] == "claude-code"
        assert result["doctor"]["next_steps"][0] == f"hbn install --runtime claude-code --target {target}"


def test_quickstart_initializes_target_and_creates_note():
    with tempfile.TemporaryDirectory() as td:
        target = (Path(td) / "sandbox").resolve()
        args = _parse_args(["quickstart", "--target", str(target), "--runtime", "codex"])
        result = run_quickstart(args)
        assert result["quickstart"]["status"] == "ready"
        assert result["quickstart"]["initialized"] is True
        assert result["quickstart"]["adapter_installed"]["runtime"] == "codex"
        assert (target / ".hbn" / "relay" / "0001-Quickstart.md").exists()


def test_result_with_environment():
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)
        from usehbn.protocol.result import create_result_record

        record = create_result_record(
            execution_id="exec-env-test",
            agent_id="codex",
            hbn_outcome="executed",
            human_status="approved",
            action_taken="Test with env",
            environment={"node_version": "20.11.0", "network_available": True},
            storage_dir=Path(td),
        )
        assert "environment" in record
        assert record["environment"]["node_version"] == "20.11.0"
        assert record["environment"]["network_available"] is True


def test_two_agent_handoff_cycle():
    """Integration test: simulate a full two-agent handoff cycle."""
    with tempfile.TemporaryDirectory() as td:
        target = Path(td)

        # Step 1: Initialize
        init_args = _parse_args(["init", "--target", str(target)])
        init_result = run_init(init_args)
        assert init_result["status"] == "initialized"

        # Step 2: Agent "codex" takes baton
        handoff_args = _parse_args([
            "handoff", "--to", "codex", "--summary", "Starting work",
            "--target", str(target)
        ])
        run_handoff(handoff_args)

        # Step 3: Agent "codex" creates readback in canonical .hbn/readbacks/
        readback_args = _parse_args([
            "readback", "exec-cycle-001",
            "--agent-id", "codex",
            "--intent-json", '{"objective":"test","constraints":["no breaks"],"risks":["regression"]}',
            "--understanding", "Test cycle readback",
            "--invariant", "No breaking changes",
            "--plan-step", "Run the test",
            "--storage-dir", str(target),
        ])
        readback_result = run_readback_protocol(readback_args)
        assert readback_result["readback_record"]["hearback_status"] == "pending"

        # Step 4: Attempt handoff with pending readback → must fail.
        # R1 state unification — _find_pending_readbacks reads canonical
        # .hbn/readbacks/ plus legacy .usehbn/readbacks/ read-only.
        handoff_fail_args = _parse_args([
            "handoff", "--to", "claude", "--summary", "Should fail",
            "--target", str(target)
        ])
        fail_result = run_handoff(handoff_fail_args)
        assert "error" in fail_result

        # Step 5: Hearback confirmation
        hearback_args = _parse_args([
            "hearback", "exec-cycle-001", "--status", "confirmed",
            "--storage-dir", str(target),
        ])
        hearback_result = run_hearback_protocol(hearback_args)
        assert hearback_result["readback_record"]["hearback_status"] == "confirmed"

        # R1: canonical readbacks live in .hbn/readbacks/.

        # Step 6: Handoff to claude → should succeed
        handoff_ok_args = _parse_args([
            "handoff", "--to", "claude", "--summary", "DEV passed. Review needed.",
            "--target", str(target)
        ])
        ok_result = run_handoff(handoff_ok_args)
        assert "handoff" in ok_result
        assert ok_result["handoff"]["to"] == "claude"

        # Step 7: Verify relay state
        status_args = _parse_args(["relay", "status", "--target", str(target)])
        status_result = run_relay_status(status_args)
        assert status_result["relay_status"]["baton_owner"] == "claude"

        # Step 8: Final handoff back to human
        final_args = _parse_args([
            "handoff", "--to", "human", "--summary", "Review complete.",
            "--target", str(target)
        ])
        final_result = run_handoff(final_args)
        assert final_result["handoff"]["to"] == "human"


# ----------------------------------------------------------------------------
# Onda 3 (Relay Invariants em Runtime) — 6 new tests per .hbn/relay/0009-*.md
# ----------------------------------------------------------------------------


def test_handoff_blocks_on_pending_canonical_readback():
    """Pending readback in canonical .hbn/readbacks/ must block handoff."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        init_args = _parse_args(["init", "--target", str(target)])
        run_init(init_args)

        readback_args = _parse_args([
            "readback", "exec-pending-001",
            "--agent-id", "test-agent",
            "--intent-json", json.dumps({
                "objective": "test",
                "constraints": [],
                "risks": [],
                "validation_requirements": [],
            }),
            "--guardian-json", json.dumps({"status": "ok", "warnings": []}),
            "--understanding", "x",
            "--invariant", "y",
            "--plan-step", "z",
            "--storage-dir", str(target),
        ])
        run_readback_protocol(readback_args)

        hbn_readbacks = target / ".hbn" / "readbacks"
        assert any(hbn_readbacks.glob("*.json")), \
            "Readback should land in canonical .hbn/readbacks/"

        handoff_args = _parse_args([
            "handoff", "--to", "claude", "--summary", "Should fail (pending)",
            "--target", str(target)
        ])
        result = run_handoff(handoff_args)
        assert "error" in result, "Handoff must fail with pending readback"
        assert "pending" in result["error"].lower()


def test_handoff_blocks_on_pending_legacy_usehbn_readback():
    """Pending legacy readback in .usehbn/readbacks/ remains a read-only blocker."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        init_args = _parse_args(["init", "--target", str(target)])
        run_init(init_args)

        legacy_dir = target / ".usehbn" / "readbacks"
        legacy_dir.mkdir(parents=True, exist_ok=True)
        (legacy_dir / "exec-legacy-pending.json").write_text(
            json.dumps({"execution_id": "exec-legacy-pending", "hearback_status": "pending"}),
            encoding="utf-8",
        )

        handoff_args = _parse_args([
            "handoff", "--to", "claude", "--summary", "Should fail (legacy pending)",
            "--target", str(target)
        ])
        result = run_handoff(handoff_args)
        assert "error" in result, "Handoff must fail with pending legacy readback"
        assert result["pending_readbacks"] == ["exec-legacy-pending"]


def test_hearback_migrates_legacy_usehbn_readback_to_canonical_hbn():
    """Hearback can read legacy .usehbn/readbacks/ and writes the update to .hbn/."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        legacy_dir = target / ".usehbn" / "readbacks"
        legacy_dir.mkdir(parents=True, exist_ok=True)
        legacy_record = {
            "readback_id": "readback-exec-legacy-hearback",
            "execution_id": "exec-legacy-hearback",
            "agent_id": "codex",
            "track": "safe_track",
            "hearback_status": "pending",
            "understanding": "Legacy pending readback.",
            "invariants_preserved": ["Keep contract"],
            "action_plan": ["Confirm hearback"],
            "classification_basis": {
                "has_guardian_warnings": False,
                "has_risks": True,
                "has_constraints": False,
            },
            "created_at": "2026-06-16T00:00:00Z",
        }
        (legacy_dir / "exec-legacy-hearback.json").write_text(
            json.dumps(legacy_record),
            encoding="utf-8",
        )

        hearback_args = _parse_args([
            "hearback", "exec-legacy-hearback", "--status", "confirmed",
            "--storage-dir", str(target),
        ])
        result = run_hearback_protocol(hearback_args)
        assert result["readback_record"]["hearback_status"] == "confirmed"

        canonical_path = target / ".hbn" / "readbacks" / "exec-legacy-hearback.json"
        assert canonical_path.exists()
        canonical = json.loads(canonical_path.read_text(encoding="utf-8"))
        assert canonical["hearback_status"] == "confirmed"

        legacy = json.loads((legacy_dir / "exec-legacy-hearback.json").read_text(encoding="utf-8"))
        assert legacy["hearback_status"] == "pending"


def test_find_pending_readbacks_dedups_when_present_in_both_dirs():
    """Same execution_id in both readback dirs must appear once."""
    from usehbn.cli import _find_pending_readbacks
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        run_init(_parse_args(["init", "--target", str(target)]))

        record = {"execution_id": "exec-dup-001", "hearback_status": "pending"}
        for dir_path in [target / ".hbn" / "readbacks", target / ".usehbn" / "readbacks"]:
            dir_path.mkdir(parents=True, exist_ok=True)
            (dir_path / "exec-dup-001.json").write_text(json.dumps(record), encoding="utf-8")

        pending = _find_pending_readbacks(target)
        assert pending.count("exec-dup-001") == 1, f"Expected dedup; got {pending}"


def test_handoff_audit_trail_preserves_last_ten():
    """12 sequential handoffs leave audit_trail with exactly 10 entries (latest at end)."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        run_init(_parse_args(["init", "--target", str(target)]))

        for i in range(12):
            run_handoff(_parse_args([
                "handoff", "--to", f"agent-{i}", "--summary", f"step-{i}",
                "--target", str(target),
            ]))

        state = json.loads((target / ".hbn" / "relay" / "state.json").read_text(encoding="utf-8"))
        audit = state.get("audit_trail")
        assert isinstance(audit, list)
        assert len(audit) == 10, f"Expected exactly 10 entries; got {len(audit)}"
        # Newest at the end: agent-11 (12th handoff).
        assert audit[-1]["to"] == "agent-11"
        # Oldest preserved is from the 3rd handoff (agent-2), as 0 and 1 dropped.
        assert audit[0]["to"] == "agent-2"


def test_handoff_audit_trail_backward_compatible():
    """state.json without audit_trail must still accept handoff and write a new entry."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        run_init(_parse_args(["init", "--target", str(target)]))

        # Force a state.json without audit_trail (simulating pre-Onda-3 state).
        state_path = target / ".hbn" / "relay" / "state.json"
        legacy_state = {
            "baton_owner": "human",
            "baton_since": "2026-04-29T08:00:00.000000Z",
            "active_iterations": [],
            "pending_decisions": 0,
            "last_handoff": None,
        }
        state_path.write_text(json.dumps(legacy_state), encoding="utf-8")

        result = run_handoff(_parse_args([
            "handoff", "--to", "codex", "--summary", "First post-migration handoff",
            "--target", str(target),
        ]))
        assert "handoff" in result, f"Handoff should succeed; got {result}"

        new_state = json.loads(state_path.read_text(encoding="utf-8"))
        assert "audit_trail" in new_state
        assert isinstance(new_state["audit_trail"], list)
        assert len(new_state["audit_trail"]) == 1
        assert new_state["audit_trail"][0]["to"] == "codex"


def test_relay_status_baton_stale_flag_when_configured():
    """baton_staleness_seconds=0 forces baton_stale=True (always-stale config)."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        run_init(_parse_args(["init", "--target", str(target)]))

        state_path = target / ".hbn" / "relay" / "state.json"
        state = {
            "baton_owner": "agent",
            "baton_since": "2026-04-29T08:00:00.000000Z",
            "active_iterations": [],
            "pending_decisions": 0,
            "last_handoff": None,
            "baton_staleness_seconds": 0,
        }
        state_path.write_text(json.dumps(state), encoding="utf-8")

        result = run_relay_status(_parse_args(["relay", "status", "--target", str(target)]))
        assert result.get("baton_stale") is True


def test_relay_status_no_baton_stale_field_by_default():
    """Without baton_staleness_seconds set, run_relay_status must not include baton_stale."""
    with tempfile.TemporaryDirectory() as tmpdir:
        target = Path(tmpdir)
        run_init(_parse_args(["init", "--target", str(target)]))

        result = run_relay_status(_parse_args(["relay", "status", "--target", str(target)]))
        assert "baton_stale" not in result, \
            f"baton_stale must be absent when not configured; got keys: {list(result.keys())}"

"""Tests for HBN relay enforcement, handoff, refresh, and new CLI features.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
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

        # Step 3: Agent "codex" creates readback in .usehbn/ (default state dir)
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

        # Step 4: Attempt handoff with pending readback → must fail
        # Note: handoff checks .hbn/readbacks/, not .usehbn/readbacks/
        # So we need to copy readback to .hbn/readbacks/ for the validation
        hbn_readbacks = target / ".hbn" / "readbacks"
        hbn_readbacks.mkdir(parents=True, exist_ok=True)
        usehbn_readback = target / ".usehbn" / "readbacks" / "exec-cycle-001.json"
        if usehbn_readback.exists():
            import shutil
            shutil.copy2(str(usehbn_readback), str(hbn_readbacks / "exec-cycle-001.json"))

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

        # Also update the .hbn/ copy
        if (hbn_readbacks / "exec-cycle-001.json").exists():
            confirmed_record = json.loads(
                (target / ".usehbn" / "readbacks" / "exec-cycle-001.json").read_text(encoding="utf-8")
            )
            (hbn_readbacks / "exec-cycle-001.json").write_text(
                json.dumps(confirmed_record), encoding="utf-8"
            )

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

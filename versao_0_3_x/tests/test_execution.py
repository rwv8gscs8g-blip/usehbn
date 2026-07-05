import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.execution.engine import execute_request


class ExecutionEngineTests(unittest.TestCase):
    def test_execution_creates_log_and_state_entries(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            base_dir = Path(temp_dir)
            result = execute_request("usehbn analyze this system", storage_dir=base_dir)

            log_path = Path(result["execution"]["log_path"])
            self.assertTrue(log_path.exists())
            self.assertEqual(log_path.parent.name, "logs")

            log_payload = json.loads(log_path.read_text(encoding="utf-8"))
            self.assertEqual(log_payload["input"], "usehbn analyze this system")
            self.assertEqual(log_payload["parsed_intent"]["objective"], "analyze this system")
            self.assertEqual(log_payload["validation_results"]["status"], "clear")

            state_path = Path(result["execution"]["state_path"])
            self.assertTrue(state_path.exists())

            state_payload = json.loads(state_path.read_text(encoding="utf-8"))
            self.assertEqual(len(state_payload["executions"]), 1)
            self.assertEqual(state_payload["executions"][0]["execution_id"], result["execution"]["id"])
            self.assertTrue(state_payload["decisions"])
            self.assertEqual(state_payload["context_history"][0]["objective"], "analyze this system")

    def test_non_trigger_execution_is_logged_as_inactive(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            result = execute_request("analyze this system", storage_dir=Path(temp_dir))
            self.assertFalse(result["hbn_activated"])
            self.assertEqual(result["validation"]["status"], "idle")


if __name__ == "__main__":
    unittest.main()

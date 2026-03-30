import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.protocol.consent import CONSENT_QUESTION, create_consent_record


class ConsentProtocolTests(unittest.TestCase):
    def test_creates_local_consent_record(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            record = create_consent_record(
                scope="language_advancement",
                duration="session",
                contribution_units=3,
                allowed_operations=["local_storage", "schema_validation"],
                storage_dir=Path(temp_dir),
            )

            self.assertEqual(record["question"], CONSENT_QUESTION)
            self.assertEqual(record["contribution_units"], 3)

            file_path = Path(record["storage_path"])
            self.assertTrue(file_path.exists())

            saved = json.loads(file_path.read_text(encoding="utf-8"))
            self.assertTrue(saved["granted"])
            self.assertTrue(saved["revocable"])
            self.assertEqual(saved["allowed_operations"][0], "local_storage")
            self.assertTrue(saved["created_at"].endswith("Z"))
            self.assertNotIn("+00:00", saved["created_at"])


if __name__ == "__main__":
    unittest.main()

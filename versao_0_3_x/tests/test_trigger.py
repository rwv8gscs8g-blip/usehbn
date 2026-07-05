import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.trigger import detect_activation


class TriggerDetectionTests(unittest.TestCase):
    def test_detects_compact_trigger(self) -> None:
        payload = detect_activation("Please usehbn analyze this system.")
        self.assertTrue(payload["hbn_activated"])
        self.assertEqual(payload["stage"], "intent_capture")

    def test_detects_spaced_trigger_case_insensitively(self) -> None:
        payload = detect_activation("Can you USE HBN review this flow?")
        self.assertTrue(payload["hbn_activated"])
        self.assertEqual(payload["normalized_trigger"], "usehbn")

    def test_ignores_non_trigger_text(self) -> None:
        payload = detect_activation("Please review this flow carefully.")
        self.assertFalse(payload["hbn_activated"])
        self.assertEqual(payload["stage"], "idle")

    def test_domain_reference_still_normalizes_to_usehbn(self) -> None:
        payload = detect_activation("Read the protocol reference at usehbn.org before proceeding.")
        self.assertTrue(payload["hbn_activated"])
        self.assertEqual(payload["normalized_trigger"], "usehbn")


if __name__ == "__main__":
    unittest.main()

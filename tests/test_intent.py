import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from usehbn.protocol.intent import structure_intent
from usehbn.trigger import detect_activation


class IntentStructuringTests(unittest.TestCase):
    def test_extracts_objective_constraints_and_validation(self) -> None:
        sentence = "use hbn migrate this service without downtime and validate with unit tests"
        activation = detect_activation(sentence)
        intent = structure_intent(sentence, activation)

        self.assertEqual(
            intent["objective"],
            "migrate this service without downtime and validate with unit tests",
        )
        self.assertIn("without downtime", intent["constraints"])
        self.assertIn("validate with unit tests", intent["validation_requirements"])
        self.assertTrue(intent["risks"])

    def test_infers_security_risk_keyword(self) -> None:
        sentence = "usehbn review the authentication flow and verify rollback coverage"
        intent = structure_intent(sentence, detect_activation(sentence))

        self.assertIn(
            "Authentication flows require correctness and rollback planning.",
            intent["risks"],
        )
        self.assertIn("verify rollback coverage", intent["validation_requirements"])


if __name__ == "__main__":
    unittest.main()

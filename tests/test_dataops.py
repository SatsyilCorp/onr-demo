import unittest
from src.dataops.schema_validator import SchemaValidator

class TestDataOps(unittest.TestCase):
    def test_schema_validator_valid(self):
        target_schema = {
            "event_id": "string",
            "timestamp": "timestamp",
            "amount": "double"
        }
        validator = SchemaValidator(target_schema)
        payload = {
            "event_id": "evt_12345",
            "timestamp": "2026-08-13T12:00:00Z",
            "amount": 4500.0
        }
        result = validator.validate_incoming_payload(payload)
        self.assertTrue(result["is_valid"])
        self.assertFalse(result["schema_drift_detected"])
        self.assertEqual(result["status"], "PASS")

    def test_schema_validator_missing_field(self):
        target_schema = {
            "event_id": "string",
            "timestamp": "timestamp",
            "amount": "double"
        }
        validator = SchemaValidator(target_schema)
        payload = {
            "event_id": "evt_12345",
            "amount": 4500.0
        }
        result = validator.validate_incoming_payload(payload)
        self.assertFalse(result["is_valid"])
        self.assertTrue(result["schema_drift_detected"])
        self.assertIn("timestamp", result["missing_fields"])
        self.assertEqual(result["status"], "SCHEMA_DRIFT_ALERT")

if __name__ == "__main__":
    unittest.main()

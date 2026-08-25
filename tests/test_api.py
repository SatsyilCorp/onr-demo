import unittest

try:
    from fastapi.testclient import TestClient
    from src.main import app
    HAS_FASTAPI = True
except ImportError:
    HAS_FASTAPI = False

class TestAPI(unittest.TestCase):
    def setUp(self):
        if HAS_FASTAPI:
            self.client = TestClient(app)

    def test_health_check(self):
        if not HAS_FASTAPI:
            self.skipTest("fastapi not installed in local environment")
        response = self.client.get("/healthz")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data["status"], "healthy")
        self.assertIn("compliance", data)

    def test_readiness_check(self):
        if not HAS_FASTAPI:
            self.skipTest("fastapi not installed in local environment")
        response = self.client.get("/ready")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()["ready"])

    def test_forecast_budget_endpoint(self):
        if not HAS_FASTAPI:
            self.skipTest("fastapi not installed in local environment")
        payload = {
            "historical_expenditures": [100.0, 120.0, 115.0, 130.0, 140.0],
            "projection_horizon_months": 6,
            "confidence_level": 0.95
        }
        response = self.client.post("/api/v1/analytics/forecast-budget", json=payload)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(len(data["projected_expenditures"]), 6)
        self.assertEqual(data["status"], "OPTIMAL")

    def test_nlp_analysis_endpoint(self):
        if not HAS_FASTAPI:
            self.skipTest("fastapi not installed in local environment")
        payload = {
            "document_text": "The Department of Defense achieved efficient growth in FY2026 operations."
        }
        response = self.client.post("/api/v1/ai/nlp-analyze", json=payload)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertGreater(data["word_count"], 0)
        self.assertEqual(data["classification"], "STRATEGIC_PLANNING")

    def test_governance_catalog(self):
        if not HAS_FASTAPI:
            self.skipTest("fastapi not installed in local environment")
        response = self.client.get("/api/v1/governance/catalog")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertGreater(len(data["datasets"]), 0)

if __name__ == "__main__":
    unittest.main()

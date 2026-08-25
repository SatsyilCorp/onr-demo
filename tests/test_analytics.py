import unittest
from src.analytics.budget_forecasting import compute_budget_projection

class TestBudgetForecasting(unittest.TestCase):
    def test_compute_budget_projection_success(self):
        historical = [50000.0, 52000.0, 51000.0, 53500.0, 55000.0]
        horizon = 12
        result = compute_budget_projection(historical, horizon, confidence_level=0.95)
        
        self.assertEqual(len(result["projected_expenditures"]), 12)
        self.assertGreater(result["mean_forecast"], 0)
        self.assertLessEqual(result["confidence_lower_bound"], result["mean_forecast"])
        self.assertGreaterEqual(result["confidence_upper_bound"], result["mean_forecast"])
        self.assertEqual(result["status"], "OPTIMAL")

    def test_compute_budget_projection_empty_error(self):
        with self.assertRaises(ValueError):
            compute_budget_projection([], 12)

if __name__ == "__main__":
    unittest.main()

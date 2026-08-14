import unittest
from src.mlops.drift_detector import evaluate_feature_drift, calculate_population_stability_index

class TestMLOps(unittest.TestCase):
    def test_evaluate_feature_drift_no_drift(self):
        baseline = [0.1 * i for i in range(100)]
        current = [0.1 * i + 0.01 for i in range(100)]
        
        res = evaluate_feature_drift(baseline, current, alpha_threshold=0.01)
        self.assertFalse(res["drift_detected"])
        self.assertEqual(res["action"], "NO_ACTION")

    def test_evaluate_feature_drift_with_drift(self):
        baseline = [1.0 for _ in range(100)]
        current = [50.0 for _ in range(100)]
        
        res = evaluate_feature_drift(baseline, current, alpha_threshold=0.01)
        self.assertTrue(res["drift_detected"])
        self.assertEqual(res["action"], "TRIGGER_RETRAINING_PIPELINE")

    def test_psi_calculation(self):
        expected = [float(i) for i in range(100)]
        actual = [float(i) + 0.5 for i in range(100)]
        
        psi = calculate_population_stability_index(expected, actual)
        self.assertGreaterEqual(psi, 0.0)

if __name__ == "__main__":
    unittest.main()

"""
Automated MLOps Model Drift & Decay Monitoring Engine.
Monitors deployed ML models for statistical data drift and triggers retraining workflows.
"""

from typing import Dict, Any, List
import math

try:
    import numpy as np
    from scipy.stats import ks_2samp
    HAS_SCIPY = True
except ImportError:
    HAS_SCIPY = False

def evaluate_feature_drift(
    baseline_distribution: List[float],
    current_distribution: List[float],
    alpha_threshold: float = 0.01
) -> Dict[str, Any]:
    """
    Performs statistical two-sample comparison to detect distribution drift.
    """
    if HAS_SCIPY:
        base_arr = np.array(baseline_distribution, dtype=np.float64)
        curr_arr = np.array(current_distribution, dtype=np.float64)
        ks_stat, p_value = ks_2samp(base_arr, curr_arr)
        drift_detected = bool(p_value < alpha_threshold)
    else:
        # Standard deviation / mean delta fallback
        b_mean = sum(baseline_distribution) / len(baseline_distribution)
        c_mean = sum(current_distribution) / len(current_distribution)
        b_var = sum((x - b_mean) ** 2 for x in baseline_distribution) / len(baseline_distribution)
        b_std = math.sqrt(b_var) if b_var > 0 else 1.0
        drift_magnitude = abs(c_mean - b_mean) / b_std
        drift_detected = drift_magnitude > 2.0
        ks_stat = float(drift_magnitude)
        p_value = 0.001 if drift_detected else 0.50

    return {
        "ks_statistic": float(ks_stat),
        "p_value": float(p_value),
        "alpha_threshold": alpha_threshold,
        "drift_detected": drift_detected,
        "retraining_required": drift_detected,
        "action": "TRIGGER_RETRAINING_PIPELINE" if drift_detected else "NO_ACTION"
    }

def calculate_population_stability_index(
    expected: List[float],
    actual: List[float],
    num_buckets: int = 10
) -> float:
    """Calculates Population Stability Index (PSI) for model decay tracking."""
    if not expected or not actual:
        return 0.0
    
    min_val = min(min(expected), min(actual))
    max_val = max(max(expected), max(actual))
    
    if min_val == max_val:
        return 0.0
    
    step = (max_val - min_val) / num_buckets
    exp_counts = [0] * num_buckets
    act_counts = [0] * num_buckets
    
    for v in expected:
        idx = min(int((v - min_val) / step), num_buckets - 1)
        exp_counts[idx] += 1
        
    for v in actual:
        idx = min(int((v - min_val) / step), num_buckets - 1)
        act_counts[idx] += 1
        
    psi = 0.0
    for e, a in zip(exp_counts, act_counts):
        exp_pct = (e + 1e-6) / len(expected)
        act_pct = (a + 1e-6) / len(actual)
        psi += (act_pct - exp_pct) * math.log(act_pct / exp_pct)
        
    return float(psi)

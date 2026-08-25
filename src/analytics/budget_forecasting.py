"""
Statistical forecasting and optimization engine for projecting budget execution,
operational milestones, and S&T capabilities.
"""

from typing import List, Dict, Any
import math

try:
    import numpy as np
    HAS_NUMPY = True
except ImportError:
    HAS_NUMPY = False

def compute_budget_projection(
    historical_data: List[float],
    horizon_months: int,
    confidence_level: float = 0.95
) -> Dict[str, Any]:
    if not historical_data:
        raise ValueError("Historical data must contain at least one data point.")
    
    n = len(historical_data)
    mean_val = sum(historical_data) / n
    
    if n > 1:
        variance = sum((x - mean_val) ** 2 for x in historical_data) / (n - 1)
        std_val = math.sqrt(variance)
    else:
        std_val = mean_val * 0.05
    
    # Linear trend estimation
    if n > 1:
        x_vals = list(range(n))
        x_mean = sum(x_vals) / n
        numerator = sum((x_vals[i] - x_mean) * (historical_data[i] - mean_val) for i in range(n))
        denominator = sum((x_vals[i] - x_mean) ** 2 for i in range(n))
        slope = numerator / denominator if denominator != 0 else 0.0
        intercept = mean_val - slope * x_mean
    else:
        slope, intercept = 0.0, mean_val
        
    projections = [slope * (n + i) + intercept for i in range(horizon_months)]
    
    # Confidence bounds
    z_score = 1.96 if confidence_level >= 0.95 else 1.645
    margin = z_score * std_val
    forecast_mean = sum(projections) / len(projections) if projections else 0.0
    
    return {
        "projected_expenditures": [max(0.0, float(p)) for p in projections],
        "mean_forecast": float(forecast_mean),
        "confidence_lower_bound": max(0.0, float(forecast_mean - margin)),
        "confidence_upper_bound": float(forecast_mean + margin),
        "status": "OPTIMAL"
    }

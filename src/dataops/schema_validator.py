"""
DataOps Automated Schema Drift & Quality Gate.
Compares incoming streaming event payloads against registered Delta Lake table schemas.
"""

from typing import Dict, Any, List, Set

class SchemaValidator:
    def __init__(self, target_schema: Dict[str, str]):
        self.target_schema = target_schema

    def validate_incoming_payload(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        target_keys: Set[str] = set(self.target_schema.keys())
        incoming_keys: Set[str] = set(payload.keys())
        
        missing_fields = list(target_keys - incoming_keys)
        unexpected_fields = list(incoming_keys - target_keys)
        
        is_valid = len(missing_fields) == 0 and len(unexpected_fields) == 0
        
        return {
            "is_valid": is_valid,
            "schema_drift_detected": not is_valid,
            "missing_fields": missing_fields,
            "unexpected_fields": unexpected_fields,
            "status": "PASS" if is_valid else "SCHEMA_DRIFT_ALERT"
        }

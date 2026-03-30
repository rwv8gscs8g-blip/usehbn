"""Minimal schema validation helpers for HBN.

Copyright (C) 2026 Luis Mauricio Junqueira Zanin
Licensed under the GNU Affero General Public License v3.0 or later.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List

from usehbn.utils.config import schemas_dir


def load_schema(schema_name: str) -> Dict[str, Any]:
    schema_path = schemas_dir() / schema_name
    return json.loads(schema_path.read_text(encoding="utf-8"))


def assert_valid_payload(payload: Dict[str, Any], schema_name: str) -> None:
    schema = load_schema(schema_name)
    errors = _validate_node(payload, schema, path="$")
    if errors:
        raise ValueError("; ".join(errors))


def _validate_node(value: Any, schema: Dict[str, Any], path: str) -> List[str]:
    errors: List[str] = []
    schema_type = schema.get("type")

    if schema_type == "object":
        if not isinstance(value, dict):
            return [f"{path} must be an object"]

        required = schema.get("required", [])
        for field in required:
            if field not in value:
                errors.append(f"{path}.{field} is required")

        properties = schema.get("properties", {})
        for key, child in properties.items():
            if key in value:
                errors.extend(_validate_node(value[key], child, f"{path}.{key}"))
        return errors

    if schema_type == "array":
        if not isinstance(value, list):
            return [f"{path} must be an array"]
        if "minItems" in schema and len(value) < schema["minItems"]:
            errors.append(f"{path} must contain at least {schema['minItems']} item(s)")
        item_schema = schema.get("items")
        if item_schema:
            for index, item in enumerate(value):
                errors.extend(_validate_node(item, item_schema, f"{path}[{index}]"))
        return errors

    if schema_type == "string":
        if not isinstance(value, str):
            return [f"{path} must be a string"]
        if "minLength" in schema and len(value) < schema["minLength"]:
            errors.append(f"{path} must have length >= {schema['minLength']}")
        if "maxLength" in schema and len(value) > schema["maxLength"]:
            errors.append(f"{path} must have length <= {schema['maxLength']}")
        if "enum" in schema and value not in schema["enum"]:
            errors.append(f"{path} must be one of {schema['enum']}")
        return errors

    if schema_type == "integer":
        if isinstance(value, bool) or not isinstance(value, int):
            return [f"{path} must be an integer"]
        if "minimum" in schema and value < schema["minimum"]:
            errors.append(f"{path} must be >= {schema['minimum']}")
        return errors

    if schema_type == "boolean":
        if not isinstance(value, bool):
            return [f"{path} must be a boolean"]
        return errors

    return errors

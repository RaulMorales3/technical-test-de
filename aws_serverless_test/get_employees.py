import json
import os
from decimal import Decimal
from typing import Any, Dict, List

import boto3
from boto3.dynamodb.types import TypeDeserializer

DYNAMO_TABLE_NAME = os.getenv("DYNAMO_TABLE")

type_deserializer = TypeDeserializer()


def parse_dynamo_response(*, dynamo_response: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Removes dynamo types and return a dict of field name as key and value

    Args:
        dynamo_response (Dict[str, Any]): Response from DynamoDB client API

    Returns:
        List[Dict[str, Any]]: List of employees without dynamo types
    """
    return [
        type_deserializer.deserialize({"M": employee})
        for employee in dynamo_response["Items"]
    ]


def normalize_json_response(employee: Dict[str, Any]) -> Dict[str, Any]:
    """check decimal fields and transform them to string

    Args:
        employee (Dict[str, Any]): dict containing employee info

    Returns:
        Dict[str, Any]: dict containing employee info with str type instead of decimal.Decimal
    """
    for key, value in employee.items():
        if isinstance(value, Decimal):
            employee[key] = str(value)
    return employee


def get_employees(*, dynamo_client) -> List[Dict[str, Any]]:
    """request dynamo table and returns five employees

    Args:
        dynamo_client (DynamoDB): client for dynamodb

    Returns:
        List[Dict[str, Any]]: list of employees limit to 5
    """
    res = dynamo_client.scan(
        TableName=DYNAMO_TABLE_NAME, Select="ALL_ATTRIBUTES", Limit=5
    )
    employees = parse_dynamo_response(dynamo_response=res)
    return list(map(normalize_json_response, employees))


def get_employee(*, dynamo_client, employee_id: str) -> List[Dict[str, Any]]:
    """Request dynamo table and search for an employees' id if not found returns
    an empty list

    Args:
        dynamo_client (DynamoDB): client for dynamodb
        employee_id (str): id to loof for in the table

    Returns:
        List[Dict[str, Any]]: A list with the employee if found
    """
    res = dynamo_client.scan(
        TableName=DYNAMO_TABLE_NAME,
        Select="ALL_ATTRIBUTES",
        ScanFilter={
            "Id": {
                "AttributeValueList": [{"N": employee_id}],
                "ComparisonOperator": "EQ",
            }
        },
    )
    employee = parse_dynamo_response(dynamo_response=res)
    return list(map(normalize_json_response, employee))


def lambda_handler(event, context):
    session = boto3.Session()
    dynamodb = session.client("dynamodb")
    parameters = event.get("pathParameters")
    if not parameters:
        body = get_employees(dynamo_client=dynamodb)
    else:
        body = get_employee(
            dynamo_client=dynamodb, employee_id=parameters.get("employee_id")
        )
    return {"statusCode": 200, "body": json.dumps(body)}

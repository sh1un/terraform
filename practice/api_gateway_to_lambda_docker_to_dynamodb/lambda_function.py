import json
import logging
import os

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource("dynamodb")
table_name = os.getenv("DYNAMODB_TABLE", "demo")
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    try:
        response = table.scan()
        items = response.get("Items", [])
        print("test12")

        logger.info("Scan succeeded: %s", json.dumps(items))

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"items": items}),
        }
    except Exception as e:
        logger.error("Error scanning DynamoDB table: %s", e)
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }


if __name__ == "__main__":
    pass

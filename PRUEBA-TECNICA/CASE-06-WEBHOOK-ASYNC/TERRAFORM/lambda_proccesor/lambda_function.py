import json
import os
import time
import boto3
from datetime import datetime, timezone

dynamodb = boto3.client("dynamodb")

TABLE_NAME = os.environ["TABLE_NAME"]

def lambda_handler(event, context):

    for record in event["Records"]:

        message = json.loads(record["body"])
        execution_id = message["execution_id"]

        dynamodb.update_item(
            TableName=TABLE_NAME,
            Key={
                "execution_id": {
                    "S": execution_id
                }
            },
            UpdateExpression="SET #s = :s",
            ExpressionAttributeNames={
                "#s": "status"
            },
            ExpressionAttributeValues={
                ":s": {
                    "S": "PROCESSING"
                }
            }
        )

        time.sleep(17)

        dynamodb.update_item(
            TableName=TABLE_NAME,
            Key={
                "execution_id": {
                    "S": execution_id
                }
            },
            UpdateExpression="SET #s = :s",
            ExpressionAttributeNames={
                "#s": "status"
            },
            ExpressionAttributeValues={
                ":s": {
                    "S": "COMPLETED"
                }
            }
        )

    return {
        "statusCode": 200,
        "body": json.dumps("Success")
    }
import json
import os
import uuid
import boto3
from datetime import datetime, timezone

sqs = boto3.client("sqs")
dynamodb = boto3.resource("dynamodb")

QUEUE_URL = os.environ["QUEUE_URL"]
TABLE_NAME = os.environ["TABLE_NAME"]

table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    execution_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc).isoformat()

    body = event.get("body") or "{}"

    item = {
        "execution_id": execution_id,
        "status": "RECEIVED",
        "received_at": now,
        "updated_at": now,
        "payload": body
    }

    table.put_item(Item=item)

    sqs.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=json.dumps({
            "execution_id": execution_id,
            "payload": body
        })
    )

    return {
        "statusCode": 202,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message": "Webhook received",
            "execution_id": execution_id
        })
    }
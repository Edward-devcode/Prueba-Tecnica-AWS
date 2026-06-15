resource "aws_dynamodb_table" "webhook_events" { # Create a DynamoDB table 
  name         = "case-06-webhook-events"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_id"
  attribute {
    name = "event_id"
    type = "S"
  }
  tags = {
    Name = "terraform-case-06"
  }
}

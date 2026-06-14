resource "aws_sqs_queue" "webhook_dlq" { # Crear una cola SQS para manejar los mensajes que no se puedan procesar actua como Dead Letter Queue (DLQ)
  name                      = "case-06-webhook-dlq"
  message_retention_seconds = 1209600 # Retain messages for up to 14 days  
  tags = {
    Name = "case-06-webhook-dlq"
  }
}

resource "aws_sqs_queue" "webhook_queue" { # Recibe
  name = "case-06-webhook-queue"

  visibility_timeout_seconds = 60     # Tiempo que unidad de computo tiene para procesar (ec2,lambda, etc)
  message_retention_seconds  = 345600 # Retiene mensajes hasta 4 dias.

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.webhook_dlq.arn
    maxReceiveCount     = 3 # Si falla 3 veces manda a DLQ
  })
}

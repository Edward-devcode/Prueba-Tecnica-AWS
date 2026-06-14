# ROL PARA QUE LAMBDA  RECEIVER PUEDA ESCRIBIR EN SQS , PERMISIS PARA MONITOREAR CON CLOUDWATCH
resource "aws_iam_role" "receiver_role" { # Crear un rol de IAM para la función Lambda
  name = "receiver-role"                  # El nombre del rol, por ejemplo "my-lambda-dev-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com" # Permitir que Lambda asuma este rol
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "receiver_policy" {
  name = "receiver-policy"
  role = aws_iam_role.receiver_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = aws_sqs_queue.webhook_queue.arn
      }
    ]
  })
}


# ROL PARA QUE LAMBDA PROCESSOR PUEDA LEER SQS Y PUEDA ESCRIBIR SOBRE DYNAMOBD, PERMISOS PARA MONITOREAR COMO CLOUDWATCH
resource "aws_iam_role" "processor_role" { # Crear un rol de IAM para la función Lambda
  name = "processor-role"                  # El nombre del rol, por ejemplo "my-lambda-dev-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com" # Permitir que Lambda asuma este rol
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "processor_policy" {
  name = "processor-policy"
  role = aws_iam_role.processor_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.webhook_queue.arn
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.webhook_events.arn
      }
    ]
  })
}

# ASIGNAR POLITICAS EXISTENTES EN AWS EJECUTAR CLOUDWATCH 
resource "aws_iam_role_policy_attachment" "receiver_logs" {
  role       = aws_iam_role.receiver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "processor_logs" {
  role       = aws_iam_role.processor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


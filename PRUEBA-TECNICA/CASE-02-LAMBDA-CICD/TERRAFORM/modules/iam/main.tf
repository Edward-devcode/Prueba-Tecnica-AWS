resource "aws_iam_role" "lambda_role" {                 # Crear un rol de IAM para la función Lambda
  name = "${var.function_name}-${var.environment}-role" # El nombre del rol, por ejemplo "my-lambda-dev-role"
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

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" { # Adjuntar la política de ejecución básica de Lambda al rol
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

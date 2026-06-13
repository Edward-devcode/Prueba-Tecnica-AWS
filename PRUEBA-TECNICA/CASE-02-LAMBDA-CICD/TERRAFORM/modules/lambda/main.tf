resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}-${var.environment}"
  runtime       = var.runtime
  role          = var.role_arn
  handler       = var.handler # El nombre del archivo y la función de entrada
  filename      = var.package_file
  architectures = [var.architecture] # ARM64 o x86_64
  publish       = true               # Publicar la versión después de crearla

  source_code_hash = filebase64sha256(var.package_file) # Asegura que la función se actualice si el código cambia

  environment {
    variables = var.environment_variables
  }

}

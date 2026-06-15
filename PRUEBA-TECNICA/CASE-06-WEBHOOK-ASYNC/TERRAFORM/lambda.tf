data "archive_file" "receiver_zip" {                                # COMPRIME ARCHIVOS  PYTHON EN .ZIP YA QU
  type        = "zip"                                               # Convierte a este tipo de formato
  source_file = "${path.module}/lambda_receiver/lambda_function.py" # Dirección a comprimir
  output_path = "${path.module}/lambda_receiver.zip"                # Ruta final 
}

#LAMBDA QUE RECIBE EL WEBHOOK
resource "aws_lambda_function" "receiver" {
  function_name    = "case-06-webhook-receiver-dev"
  role             = aws_iam_role.receiver_role.arn   #ROL IAM
  handler          = "lambda_function.lambda_handler" #PROGRAMA A EJECUTAR
  runtime          = "python3.12"
  filename         = data.archive_file.receiver_zip.output_path         # QUE ARCHIVO .ZIP DEBE SUBIR A ESTE LAMBDA
  source_code_hash = data.archive_file.receiver_zip.output_base64sha256 # PERMITE A TERRAFORM DETECTAR CAMBIOS EN LA RUTA ORIGEN
  timeout          = 3                                                  # TIEMPO DE EJECUCIÓN DEL LAMBDA 

  environment { #LE PERMITE A LAMBDA LEER EL SQS DONDE GUARDARA INFO
    variables = {
      QUEUE_URL = aws_sqs_queue.webhook_queue.url
    }
  }
}

data "archive_file" "processor_zip" { # COMPRIME ARCHIVOS  PYTHON EN .ZIP 
  type        = "zip"
  source_file = "${path.module}/lambda_processor/lambda_function.py"
  output_path = "${path.module}/lambda_processor.zip"
}

#LAMBDA QUE PROCESA DESDE SQS 
resource "aws_lambda_function" "processor" {
  function_name    = "case-06-webhook-processor-dev"
  role             = aws_iam_role.processor_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.processor_zip.output_path
  source_code_hash = data.archive_file.processor_zip.output_base64sha256
  timeout          = 30

  environment { #PASAS  DATOS QUE EL CODIGO DE PYTHON PUEDE LEER 
    variables = {
      TABLE_NAME = aws_dynamodb_table.webhook_events.name
    }
  }
}

#CONECTAR SQS CON LAMBDA QUE PROCESA CADA QUE SQS TENGA MENSAJE ESTE INVOCA A LAMBDA PROCESSOR
resource "aws_lambda_event_source_mapping" "processor_sqs_trigger" {
  event_source_arn = aws_sqs_queue.webhook_queue.arn
  function_name    = aws_lambda_function.processor.arn

  batch_size = 1 # ENTREGA UN MENSAJE POR EJECUCION 
}


#APIGATEWAY  PARA EXPONER SERVICIOS 
resource "aws_apigatewayv2_api" "webhook_api" {
  name          = "webhook-api"
  protocol_type = "HTTP" #PROTOCOLOS HTTP o WEBSOCKET,CON RESOURCE V1 REST
}

# INTEGRA APIGATEWAY CON EL LAMBDA (INVOCA AL LAMBDA RECEIVER)
resource "aws_apigatewayv2_integration" "receiver_integration" {
  api_id                 = aws_apigatewayv2_api.webhook_api.id
  integration_type       = "AWS_PROXY"                             #EL MENSAJE SE ENVIA A LAMBDA SIN MODIFICAR / SI QUIERES QUE SE MODIFIQUE USA "AWS"
  integration_uri        = aws_lambda_function.receiver.invoke_arn #DICE QUE LAMBDA SE EJECUTA
  integration_method     = "POST"                                  #SE USA POST PARA INVOCAR AL LAMBDA
  payload_format_version = "2.0"

}

#CREAR RUTA PUBLICA  DEL WEBHOOK
resource "aws_apigatewayv2_route" "webhook_route" {
  api_id    = aws_apigatewayv2_api.webhook_api.id
  route_key = "POST /webhook"                                                        # DEFINES ENDPOINT
  target    = "integrations/${aws_apigatewayv2_integration.receiver_integration.id}" # SI ALGUIEN INVOCA POST /webhook  APIGATEWAY USA INTEGRACION DEL RECEIVER
}

#
resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.webhook_api.id
  name        = "dev"
  auto_deploy = true
}

#
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.receiver.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.webhook_api.execution_arn}/*/*"
}

# Caso 6:
Crear un template (Terraform o CloudFormation) que despliegue:
2 Lambda
1 API Gateway
1 DynamoDB
1 SQS
permisos IAM necesarios
El objetivo de esta solicitud es crear la infraestructura necesaria para un webhook que necesita dar respuesta enmenos de 2 segundos, pero el procesamiento de la información recibida se realice de forma asíncrona ya que paraprocesar los datos se requiere al menos 17 segundos, se debe tener histórico de ejecuciones y mostrar métodos demonitoreo para el correcto uso.


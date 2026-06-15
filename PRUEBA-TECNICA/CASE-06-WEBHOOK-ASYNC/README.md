# Caso 6:
Crear un template (Terraform o CloudFormation) que despliegue:
2 Lambda
1 API Gateway
1 DynamoDB
1 SQS
permisos IAM necesarios
El objetivo de esta solicitud es crear la infraestructura necesaria para un webhook que necesita dar respuesta enmenos de 2 segundos, pero el procesamiento de la información recibida se realice de forma asíncrona ya que paraprocesar los datos se requiere al menos 17 segundos, se debe tener histórico de ejecuciones y mostrar métodos demonitoreo para el correcto uso.


  WEBHOOK
     |  =GET/ USER / PUT / DELETE
API GATEWAY
     |   = POST 
LAMBDA RECEIVER (RECIBE EL WEBHOOK, VALIDA QUE EL JSON SEA VALIDO, LO ENVIA A SQS Y RESPONDE STATUS DE ENVIO)
     |
    SQS => SQS DLQ  
     |
LAMBDA PROCESSOR (CONSUME EL MENSAJE DE SQS, LLAMA API EXTERNA, TRANFORMA LOS DATO, GUARDA EN DYNAMODB Y GENERA UN RESULTADO)
     |
  DYNAMOBD

- webhook es un mecanismo basado en HTTP el cual una aplicación notifica a otra cuando un evento especifico ocurre (por ejemplo el pago completado o mensaje recibido)
-Api gateway se encarga de exponer funcionalidades del Backend en este caso Lambda reciber 
-SQS  permite desacoplar la recepcion recepción  del webhook del procesamiento  
  Se implementa una Dead Letter queue para aislar mensajes que no pueden ser procesados, esto evita la perdida de información facilita el analisis de errores 
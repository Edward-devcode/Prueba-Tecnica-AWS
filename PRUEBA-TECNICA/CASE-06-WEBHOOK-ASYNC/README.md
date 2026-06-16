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
LAMBDA RECEIVER (RECIBE EL WEBHOOK, VALIDA QUE EL JSON SEA VALIDO, GENERA requestID,  LO ENVIA A SQS Y RESPONDE STATUS DE ENVIO)
     |
    SQS => SQS DLQ  
     |
LAMBDA PROCESSOR (CONSUME EL MENSAJE DE SQS, LLAMA API EXTERNA, TRANFORMA LOS DATO, GUARDA REGISTRO EN DYNAMODB SI NO EXISTE EN REQUEST ID USANDO attribute_not_exists Y GENERA UN RESULTADO)
     |
  DYNAMOBD SI EL REQUEST YA EXISTE DYNAMO RECHAZA ESCRITURA

- webhook es un mecanismo basado en HTTP el cual una aplicación notifica a otra cuando un evento especifico ocurre (por ejemplo el pago completado o mensaje recibido)
-Api gateway se encarga de exponer funcionalidades del Backend en este caso Lambda reciber 
-SQS  permite desacoplar la recepción  del webhook del procesamiento  
  Se implementa una Dead Letter queue para aislar mensajes que no pueden ser procesados, esto evita la perdida de información y facilita el analisis de errores 

  Para la observabilidad implementaría una estrategia basada en logs estructurados, métricas y trazabilidad distribuida. Utilizaría CloudWatch para centralizar logs y métricas operativas, configuraría alarmas para errores, throttling y acumulación de mensajes en SQS, y complementaría con AWS X-Ray para obtener trazabilidad extremo a extremo entre API Gateway, Lambda, SQS y DynamoDB. Esto permitiría detectar incidentes rápidamente, identificar cuellos de botella y reducir el tiempo de diagnóstico.

  Elegí DynamoDB porque el caso requería almacenar datos simples con acceso por clave, sin relaciones complejas entre entidades. DynamoDB ofrece escalabilidad automática, alta disponibilidad administrada, baja latencia y elimina la necesidad de administrar infraestructura de base de datos.

  El tradeoff es que DynamoDB sacrifica capacidades relacionales y flexibilidad que de consultas que RDS tiene a cambio de mayor escalabilidad y simplicidad operacional.

  Si lambda Processor falla
  
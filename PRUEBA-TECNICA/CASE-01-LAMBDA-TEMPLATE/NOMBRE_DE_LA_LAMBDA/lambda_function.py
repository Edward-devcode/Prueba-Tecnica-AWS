import json

def lambda_handler(event, context):
    #Ejemplo mínimo de handler para la plantilla Lambda.
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
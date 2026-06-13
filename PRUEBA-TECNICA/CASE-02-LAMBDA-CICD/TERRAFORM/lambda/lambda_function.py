import json
import os # Importar el módulo os para acceder a las variables de entorno


def lambda_handler(event, context):

    db_host = os.environ.get("DB_HOST") # Obtener el valor de la variable de entorno DB_HOST
    redis_host = os.environ.get("REDIS_HOST") #Esta en mayusculas porque en main de labda dev se definen las variables de entorno en mayusculas, y es una convención usar mayusculas para las variables de entorno

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Lambda deployed successfully 2.0 with CI/CD pruebaaaaa!",
            "db_host": db_host,
            "redis_host": redis_host
        })
    }
  
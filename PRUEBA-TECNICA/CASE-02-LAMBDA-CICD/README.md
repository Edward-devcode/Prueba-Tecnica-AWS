# Habilitar pipelines con github action preferentemente para permitir subir cambios a lambdas, considerando 3 ambientes identificados por alias dev, staging y prod, cada ambiente debe tener su propia configuración de terraform, se debe incluir un ejemplo de lambda con su respectiva configuración de terraform

# Es importante considerar que cada ambiente va a contar con variables de entorno especificas por ejemplo redis_host y db_host.

# Es importan considerar mecanismos de roollback aptimizados.

# ROLLBACK ESTRATEGIA: PARA ROLLBACK SE PUEDE USAR VERSIONES DE LAMBDA Y ALIAS PARA APUNTAR A VERSIONES ANTERIORES EN CASO DE QUE LA NUEVA VERSIÓN TENGA PROBLEMAS, ESTO PERMITE UN ROLLBACK RÁPIDO Y CONTROLADO SIN NECESIDAD DE REVERTIR TODO EL DESPLIEGUE O HACER CAMBIOS MANUALES EN LA CONFIGURACIÓN DE TERRAFORM. CADA VEZ QUE SE DESPLIEGA UNA NUEVA VERSIÓN DE LA FUNCIÓN LAMBDA, SE CREA UNA NUEVA VERSIÓN Y SE ACTUALIZA EL ALIAS PARA APUNTAR A ESA VERSIÓN. SI SE DETECTA UN PROBLEMA CON LA NUEVA VERSIÓN, SIMPLEMENTE SE ACTUALIZA EL ALIAS PARA APUNTAR A LA VERSIÓN ANTERIOR ESTABLE, PERMITIENDO UN ROLLBACK RÁPIDO Y EFICIENTE.

# LQMBDA fUNCTION 
-Runtime: PYTHON 3.13
-Architeccture: ARM64
Enviroment Variables:
-REDIS_HOST
-DB_HOST

 HANDLER: lambda_function.lambda_handler # EL NOMBRE DEL ARCHIVO DONDE SE ENCUENTRA LA FUNCION HANDLER, EN ESTE CASO lambda_function.py Y EL NOMBRE DE LA FUNCION DENTRO DE ESE ARCHIVO QUE SERA EL PUNTO DE ENTRADA DE LA LAMBDA, EN ESTE CASO lambda_handler.

Para la configuración de terraform, se debe crear un módulo para la lambda que incluya la definición de la función lambda, el rol de ejecución y las políticas necesarias. Luego, se pueden crear archivos de configuración específicos para cada ambiente (dev, staging, prod) que utilicen el módulo de lambda y definan las variables de entorno correspondientes para cada ambiente. Además, se debe configurar el backend de terraform para cada ambiente utilizando S3 y DynamoDB para el estado remoto y el bloqueo respectivamente.

# Configuración para GITHUB ACTIONS:
Crear OIDC provider en AWS IAM para permitir que GitHub Actions asuma un rol con permisos para desplegar la lambda.
Guardar las credenciales necesarias (como el ARN del rol) en los secretos de GitHub.
Usar permissions: id-token: write para permitir que GitHub Actions obtenga un token OIDC. write en el deployment workflow para permitir que GitHub Actions despliegue la lambda utilizando el rol asumido a través de OIDC. Esto asegura que el proceso de despliegue sea seguro y eficiente, sin necesidad de manejar credenciales estáticas.
# Recomendaciones adicionales: En el rol de de github actions remplazar permisos por políticas de permisos específicos para limitar el acceso solo a los recursos necesarios para el despliegue de la lambda, esto mejora la seguridad al reducir el alcance de los permisos otorgados al rol.
GitHub Actions
        │ Token OIDC
        ▼
AWS IAM OIDC Provider
        │ Validación
        ▼
IAM Role
        │ AssumeRoleWithWebIdentity
        ▼
STS
        │ Credenciales temporales
        ▼
Terraform



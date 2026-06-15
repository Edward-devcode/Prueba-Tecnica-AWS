# CASE-02: Lambda CI/CD — Guía y buenas prácticas

## Descripción
Guía para habilitar pipelines con GitHub Actions y gestionar despliegues de funciones Lambda en tres ambientes (`dev`, `staging`, `prod`). Incluye recomendaciones de Terraform, variables por ambiente, estrategia de rollback y configuración segura con OIDC.

## Objetivo
- **Automatizar despliegues** de Lambdas por ambiente.
- **Mantener estado remoto** de Terraform con bloqueo (S3 + DynamoDB).
- **Permitir rollback rápido** mediante versiones y alias de Lambda.

## Alcance
- Ejemplo de función Lambda en Python.
- Módulo Terraform reutilizable para Lambda, IAM y alias.
- Workflow de GitHub Actions usando OIDC para autenticación segura.

## Estructura del repositorio relevante
- `TERRAFORM/` : infraestructura y módulos.
- `TERRAFORM/modules/lambda/` : 

- `TERRAFORM/ENVIROMENT/{DEV,STAGING,PROD}` 

- `lambda/` o `templates/` : ejemplo de código Lambda (`lambda_function.py`).

## Requisitos
- **AWS account** con permisos para crear roles, políticas, S3 y DynamoDB.
- **GitHub repo** donde configurar Actions y secretos.
- **Terraform >= 5.0**.

## Convenciones y runtime
- **Runtime**: `python3.13` (ajustar si es necesario).
- **Arquitectura**: `arm64` recomendado para reducción de coste.
- **Handler**: `lambda_function.lambda_handler` (archivo `lambda_function.py`).

## Variables de entorno (por ambiente)
- **Obligatorias**: `REDIS_HOST`, `DB_HOST`.
- **Recomendadas**: `LOG_LEVEL`, `AWS_REGION`.
- **Cómo definirlas**: cada ambiente define sus valores en `terraform.tfvars` o variables de entorno del módulo.

## Terraform — recomendaciones
- Crear un **módulo `lambda`** que incluya:
  - `aws_lambda_function` (paquete/handler, runtime, arch)
  - `aws_iam_role` + políticas mínimas necesarias
  - `aws_lambda_alias` para cada ambiente
  - `aws_lambda_permission` si se integra con triggers
- Mantener backend remoto por ambiente: `S3` (state) + `DynamoDB` (lock).
- Archivos por ambiente: `ENVIROMENT/DEV/main.tf`, `terraform.tfvars`, `backend_*.tf`.


## Estrategia de rollback
- Publicar cada despliegue como **nueva versión** de Lambda.
- Mantener un `alias` por ambiente que apunte a la versión activa.
- Si la nueva versión falla, actualizar el alias para apuntar a la versión anterior estable.
- Opcional: usar `traffic shifting` con `aws_lambda_alias` para Canary deployments.

## Ejemplo de despliegue rápido (comandos)
```bash
# Inicializar Terraform 
INICIALIAR BOOTSTRAP 
cd TERRAFORM/BOOTSTRAP
terraform init
terraform plan 
terraform apply

cd TERRAFORM/ENVIROMENT/DEV
terraform init
terraform plan 
terraform apply 



## Ejemplo de implementación de Lambda (resumen)
- Archivo: `templates/lambda_function.py` contiene `lambda_handler`.
- Empaquetar la función (dependencias) y subir como artefacto desde el workflow.
- En Terraform, referenciar el artefacto (S3) en `filename` o `s3_key`.

## Seguridad y permisos mínimos
- Aplicar principio de privilegio mínimo en el rol asumido por GitHub Actions.
- Limitar políticas a acciones necesarias: `lambda:CreateFunction`, `lambda:UpdateAlias`, `iam:PassRole`, S3/Dynamo necesarias para estado.

## Buenas prácticas
- Versionar infra y código en Git.
- Revisiones y `terraform plan` obligatorio en PRs.
- Monitoreo y alertas en CloudWatch para detectar regresiones.

## Referencias rápidas
- OIDC + GitHub Actions: documentación oficial de GitHub y AWS IAM OIDC.
- Terraform backend S3 + DynamoDB: docs de Terraform.

#DECISIONES DE ARQUITECTURA Y RECURSOS
#Terraform
1. Terraform te permite garantizar que la infrastrura se reproducible, versionada  y auditable ademas te permite desplegarlos los mismos recursos en diferentes entornos modificando solanmente las variables por entorno.
2. Arquitectura del proyecto basada en modulos permite reparar la infrastructura por responsabilidades por ejemplo lambdas, IAM ROLES, VPC, ETC. esto te permite aislar la logica de los recursos por modulos permite que el codigo sea reutilizable , mantenible y facil de escalar, esto permite invocar el modulo desde el entorno deseado sin necesidad de copiar el codigo, permitiendo inyectar variables por entorno. 
 TRADEOFF Al inicio requiere más diseño lo que aumenta complejidad de construcción pero a mediano y largo plazo, reduce errores, aumenta escalabilidad y lo hace más legible para el equipo.
 3. Uso de bootstrap S3+Dynamobd: S3 permite almacenar el state del proyecto de forma centralizada en AWS, STATE permite tener un backend del proyecto de forma remota. El uso de dynamobd permite implementar state locking esto evita que al trabajar de manera colaborativa con un equipo en git, dos o más colaboradores puedan realizar cambios en el proyectos al mismo tiempo evitando que se corrompa el estado o exista drift entre los recurso existentes en aws y los almacenados en el proyecto. 

 4. configuraciones por ambiente dev,prod,staging  ya cada uno tiene propositos diferente y esto evita introducir errores a producción cada entorno se le inyectan variables especificas a travez de terraform.tfvars. Tradeoff: Necesita mayor complejidad en configuración pero mayor seguridad y control por entorno  

5. Uso de github actions: implemente github actions porque mi codigo fuente ya se encontraba en github lo que me permitia implementar esta herramienta de forma nativa sin administrar infrastructura adicional, además que tiene integración sencilla con AWS mediante OPEN ID CONNECT, permite ejecución bajo demanda, ademas de que permite continua integración de cambios y continuo despliege, lo que automatiza el despliegue y evita errores humanos
#flujo cicd
1. se hace push a entorno específico (dev, staging, prod)
2. se ejecuta workflow de github actions
3. autentica con OIDC y asume rol con permisos mínimos
4. empacaqueta la función Lambda 
5. ejecuta init: Necesario para inicializar provider 
6. ejecuta validate: Validar si la configuracion de terraform es valida   
7. ejecuta plan y apply de Terraform para desplegar la función y actualizar alias
8. el despliegue falla, se puede hacer rollback actualizando el alias a la versión anterior
9. el despliegue es exitoso, el alias apunta a la nueva versión 



6. Uso de OIDC le permite al pipeline tener credenciales temporaltes STS de AWS, de esta forma evito uso de credenciales estaticas en 
7. Uso de alianses y versiones para rollback automatico: 




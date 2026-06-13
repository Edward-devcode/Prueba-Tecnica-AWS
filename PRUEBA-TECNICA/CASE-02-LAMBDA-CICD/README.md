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
- `TERRAFORM/modules/lambda/` : módulo reusable para Lambdas.
- `TERRAFORM/ENVIROMENT/{DEV,STAGING,PROD}` : configuraciones por ambiente.
- `lambda/` o `templates/` : ejemplo de código Lambda (`lambda_function.py`).

## Requisitos
- **AWS account** con permisos para crear roles, políticas, S3 y DynamoDB.
- **GitHub repo** donde configurar Actions y secretos.
- **Terraform >= 1.0**.

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

## GitHub Actions — flujo recomendado
- Usar OIDC para asumir rol en AWS (sin credenciales estáticas).
- Requisitos en GitHub:
  - `permissions: id-token: write` en el workflow
  - Secrets: `TF_VAR_...` mínimos si aplica (evitar secrets de largo plazo)
  - Guardar ARN del rol de despliegue en secret (ej. `AWS_ROLE_ARN`)
- Workflow básico:
  1. `checkout`
  2. Request OIDC token y `assume-role` para obtener credenciales temporales
  3. `terraform init` con backend por ambiente
  4. `terraform plan` y `terraform apply` (con aprobación si procede)
  5. Publicar paquete Lambda y actualizar alias apuntando a la nueva versión

## Estrategia de rollback
- Publicar cada despliegue como **nueva versión** de Lambda.
- Mantener un `alias` por ambiente que apunte a la versión activa.
- Si la nueva versión falla, actualizar el alias para apuntar a la versión anterior estable.
- Opcional: usar `traffic shifting` con `aws_lambda_alias` para Canary deployments.

## Ejemplo de despliegue rápido (comandos)
```bash
# Inicializar Terraform en el ambiente DEV
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




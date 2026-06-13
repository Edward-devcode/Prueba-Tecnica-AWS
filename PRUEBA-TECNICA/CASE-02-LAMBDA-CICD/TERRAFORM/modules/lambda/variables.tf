variable "function_name" {
  type        = string
  description = "Nombre base de la función Lambda"
}

variable "environment" {
  type        = string
  description = "Ambiente: dev, staging o prod"
}

variable "role_arn" {
  type        = string
  description = "ARN del IAM Role de Lambda"
}

variable "runtime" {
  type        = string
  description = "Runtime de Lambda"
}

variable "architecture" {
  type        = string
  description = "Arquitectura de Lambda"
}

variable "handler" {
  type        = string
  description = "Handler de Lambda"
  default     = "lambda_function.lambda_handler"
}

variable "package_file" {
  type        = string
  description = "Ruta del archivo ZIP de Lambda"
}

variable "environment_variables" {
  type        = map(string)
  description = "Variables de entorno para Lambda"
}

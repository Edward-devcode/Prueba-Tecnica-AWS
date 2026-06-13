variable "function_name" { # El nombre de la función Lambda a la que se le asignará el alias
  description = "The name of the Lambda function to create"
  type        = string
}

variable "function_version" { # La versión de la función Lambda a la que apuntará el alias
  description = "The version of the Lambda function to which the alias will point"
  type        = string
}

variable "alias_name" { # El nombre del alias, por ejemplo "dev", "staging" o "prod"
  description = "The name of the alias to create (e.g., dev, staging, prod)"
  type        = string
}

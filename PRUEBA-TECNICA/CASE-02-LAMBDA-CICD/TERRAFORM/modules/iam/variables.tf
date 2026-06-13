variable "environment" {
  description = "The environment to deploy (dev, staging, prod)"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function to create"
  type        = string
}


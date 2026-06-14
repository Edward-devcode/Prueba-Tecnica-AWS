variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table to create for Terraform state locking"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

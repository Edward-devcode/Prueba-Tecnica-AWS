terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-654345678909876543"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1" #terraform no permite usar variables en el bloque backend, por eso se pone el valor directamente
    dynamodb_table = "my-terraform-lock-table"
    encrypt        = true
  }
}

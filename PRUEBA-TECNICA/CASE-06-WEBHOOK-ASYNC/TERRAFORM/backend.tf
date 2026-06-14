terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-case06-1234321"
    key            = "case06/terraform.tfstate"
    region         = "us-east-1" #terraform no permite usar variables en el bloque backend, por eso se pone el valor directamente
    dynamodb_table = "my-terraform-lock-table2"
    encrypt        = true
  }
}

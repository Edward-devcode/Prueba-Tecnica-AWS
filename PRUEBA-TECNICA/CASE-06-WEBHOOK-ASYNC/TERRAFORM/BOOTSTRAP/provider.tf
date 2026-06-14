provider "aws" { # Configure the AWS provider with the specified region and default tags for resources
  region = var.region
}

terraform { # Define the required Terraform version and providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

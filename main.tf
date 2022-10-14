terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.9" #"=1.1.8"

  backend "s3" {
    encrypt = true
  }
}

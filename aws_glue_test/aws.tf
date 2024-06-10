provider "aws" {
  region = var.region
}

terraform {
  required_version = "= 1.8.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.53.0"
    }
  }

  backend "s3" {
    bucket                  = "test-de-mybucket"
    key                     = "test-de/develpment.tfstate"
    region                  = "us-east-1"
    encrypt                 = true
    kms_key_id              = "arn:aws:kms:us-east-1:288454313657:key/4704b90e-5cef-4057-b106-63a988174eb5"
  }
}
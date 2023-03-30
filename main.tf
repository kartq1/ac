terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.16"
    }
  }
  backend "s3" {
    bucket         = "appcharge-terraform-state"
    dynamodb_table = "terraform-lock"
    encrypt        = true
    key            = "terraform.tfstate"
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

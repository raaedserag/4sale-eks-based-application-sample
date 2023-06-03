terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40.0"
    }
  }
  backend "s3" {}
  required_version = ">= 1.4.6"
}

provider "aws" {}

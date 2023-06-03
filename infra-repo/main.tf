terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
  backend "s3" {}
  required_version = ">= 1.4.6"
}

provider "aws" {}

# VPC Module
# As an alternative to this module we can use the AWS VPC module(https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
module "eks_vpc" {
  source                      = "./modules/00_AWS-EKS-Vpc-2Azs-4Subnets"
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_public_a_cidr_block  = var.subnet_public_a_cidr_block
  subnet_private_a_cidr_block = var.subnet_private_a_cidr_block
  subnet_public_b_cidr_block  = var.subnet_public_b_cidr_block
  subnet_private_b_cidr_block = var.subnet_private_b_cidr_block
}

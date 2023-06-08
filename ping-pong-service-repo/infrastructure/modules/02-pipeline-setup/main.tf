terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}



data "aws_secretsmanager_secret_version" "eks_ops_config" {
  secret_id = "/${var.namespace}/eks-ops-config"
}

locals {
  eks_ops_config     = jsondecode(data.aws_secretsmanager_secret_version.eks_ops_config.secret_string)
}

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



data "aws_secretsmanager_secret_version" "environment_config" {
  secret_id = "/${var.namespace}/${var.environment_name}/environment-config"
}

locals {
  environment_config = jsondecode(data.aws_secretsmanager_secret_version.environment_config.secret_string)
}

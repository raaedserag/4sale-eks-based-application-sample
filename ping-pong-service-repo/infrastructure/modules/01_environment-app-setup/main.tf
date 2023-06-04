terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
}

data "aws_secretsmanager_secret_version" "environment_config" {
  secret_id = "/${var.namespace}/${var.environment_name}/environment-config"
}
locals {
  environment_config = jsondecode(data.aws_secretsmanager_secret_version.environment_config.secret_string)
  namespace          = local.environment_config.NAMESPACE_NAME
  app_labels = {
    customer    = var.namespace
    app         = var.app_name
    environment = var.environment_name
  }
}
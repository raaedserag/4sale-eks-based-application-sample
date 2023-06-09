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
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}
locals {
  namespace_prefix = "${var.namespace}-${var.environment_name}"
  environment_config = {
    environment_name = var.environment_name
    k8s_cluster_name = var.k8s_cluster_config.name
    k8s_namespace   = local.namespace_prefix
  }
  mysql_config = {
    MYSQL_HOST     = aws_db_instance.current_environment_rds.address
    MYSQL_PORT     = aws_db_instance.current_environment_rds.port
    MYSQL_USER     = local.rds_username
    MYSQL_PASSWORD = local.rds_password
  }
}

data "aws_availability_zones" "available" {}

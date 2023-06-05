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


provider "random" {}
provider "aws" {
  default_tags {
    tags = {
      environment = var.environment_name
    }
  }
}
locals {
  namespace_prefix = "${var.namespace}-${var.environment_name}"
  environment_config = {
    ENVIRONMENT_NAME = var.environment_name
    K8S_NAMESPACE_NAME   = local.namespace_prefix
  }
  mysql_config = {
    MYSQL_HOST     = aws_db_instance.current_environment_rds.address
    MYSQL_PORT     = aws_db_instance.current_environment_rds.port
    MYSQL_USER     = local.rds_username
    MYSQL_PASSWORD = local.rds_password
  }
}
provider "kubernetes" {
  host                   = var.k8s_cluster_config.endpoint
  cluster_ca_certificate = base64decode(var.k8s_cluster_config.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.k8s_cluster_config.name]
    command     = "aws"
  }
  ignore_annotations = [
    "^service\\.beta\\.kubernetes\\.io\\/aws-load-balancer.*",
    "cni\\.projectcalico\\.org\\/podIP",
    "cni\\.projectcalico\\.org\\/podIPs",
  ]
}

data "aws_availability_zones" "available" {}

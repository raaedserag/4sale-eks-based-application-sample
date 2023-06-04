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

provider "aws" {
  default_tags {
    tags = {
      Namespace = var.namespace
      AppName   = var.app_name
    }
  }
}

// Retrieve EKS cluster config from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "eks_cluster_config" {
  secret_id = "/${var.namespace}/eks-cluster-config"
}
locals {
  eks_cluster_config = jsondecode(data.aws_secretsmanager_secret_version.eks_cluster_config.secret_string)
}

provider "kubernetes" {
  host                   = local.eks_cluster_config.endpoint
  cluster_ca_certificate = base64decode(local.eks_cluster_config.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.eks_cluster_config.name]
    command     = "aws"
  }
  ignore_annotations = [
    "^service\\.beta\\.kubernetes\\.io\\/aws-load-balancer.*",
    "cni\\.projectcalico\\.org\\/podIP",
    "cni\\.projectcalico\\.org\\/podIPs",
  ]
}

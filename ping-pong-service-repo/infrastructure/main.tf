terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.0"
    }
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

provider "helm" {
  kubernetes {
    host                   = local.eks_cluster_config.endpoint
    cluster_ca_certificate = base64decode(local.eks_cluster_config.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.eks_cluster_config.name]
      command     = "aws"
    }
  }
}
module "shared_app_setup" {
  source    = "./modules/00_shared-app-setup"
  namespace = var.namespace
  app_name  = var.app_name
}
module "environment_app_setup" {
  source             = "./modules/01_environment-app-setup"
  for_each           = { for env in var.environments_config : env.name => env }
  namespace          = var.namespace
  app_name           = var.app_name
  environment_name   = each.value.name
  ecr_repository_url = module.shared_app_setup.app_ecr_repository_url
}

module "pipeline_setup" {
  source               = "./modules/02-pipeline-setup"
  namespace            = var.namespace
  app_name             = var.app_name
  ecr_repository_url   = module.shared_app_setup.app_ecr_repository_url
  ecr_repository_arn   = module.shared_app_setup.app_ecr_repository_arn
  codecommit_repo_name = var.codecommit_repo_name
  repository_branch    = var.repository_branch
  environments_config  = var.environments_config
}

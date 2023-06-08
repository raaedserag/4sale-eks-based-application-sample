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
  eks_ops_config = jsondecode(data.aws_secretsmanager_secret_version.eks_ops_config.secret_string)
}


module "staging_deployment_project" {
  source = "./deployment-phase"

  namespace                 = var.namespace
  app_name                  = var.app_name
  environment_name          = "staging"
  ecr_repository_url        = var.ecr_repository_url
  cloudwatch_log_group_name = aws_cloudwatch_log_group.codepipeline_log_group.name
  pipeline_service_role_arn = data.aws_iam_role.k8s_ops_role.arn
}

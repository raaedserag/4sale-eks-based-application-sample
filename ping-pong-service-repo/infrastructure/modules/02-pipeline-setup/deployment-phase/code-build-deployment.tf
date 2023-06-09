locals {
  deployment_stage_environment_variables = {
    AWS_DEFAULT_REGION = data.aws_region.current.name
    AWS_ACCOUNT_ID     = data.aws_caller_identity.current.account_id
    ECR_REPO_URL       = var.ecr_repository_url
    APP_NAME           = var.app_name
    ENVIRONMENT_NAME   = var.environment_name
    EKS_CLUSTER_NAME   = local.environment_config.k8s_cluster_name
    EKS_NAMESPACE      = local.environment_config.k8s_namespace
    HELM_RELEASE_NAME  = "${var.app_name}-${var.environment_name}"
    HELM_CHART_PATH    = "./ping-pong-service-repo/manifest/deployment-chart"
  }
}

resource "aws_codebuild_project" "environment_deployment" {
  name          = "deploy-${var.environment_name}-${var.app_name}"
  description   = "Deploy ${var.environment_name} images for ${var.app_name}"
  build_timeout = "5"
  service_role  = var.pipeline_service_role_arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "ping-pong-service-repo/manifest/pipeline/deploy.buildspec.yml"
  }
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image                       = "aws/codebuild/standard:4.0"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    dynamic "environment_variable" {
      for_each = local.deployment_stage_environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.cloudwatch_log_group_name
      stream_name = "/${var.environment_name}/deployment"
    }
  }
}

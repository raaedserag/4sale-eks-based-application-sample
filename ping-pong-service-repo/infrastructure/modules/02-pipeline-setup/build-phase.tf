locals {
  environment_variables = {
    AWS_DEFAULT_REGION = data.aws_region.current.name
    AWS_ACCOUNT_ID     = data.aws_caller_identity.current.account_id
    ECR_REPO_URL       = var.ecr_repository_url
    APP_NAME           = var.app_name
  }
}

resource "aws_codebuild_project" "build_phase" {
  name          = "build-${var.app_name}"
  description   = "Build phase for ${var.app_name}"
  build_timeout = "5"
  service_role  = data.aws_iam_role.k8s_ops_role.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "ping-pong-service-repo/pipeline/build.buildspec.yml"
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
      for_each = local.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codepipeline_log_group.name
      stream_name = "${var.app_name}/build"
    }
  }
}


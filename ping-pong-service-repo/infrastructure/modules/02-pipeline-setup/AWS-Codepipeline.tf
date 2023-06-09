resource "aws_codepipeline" "app_pipeline" {
  name     = "${var.namespace}-${var.app_name}-pipeline"
  role_arn = data.aws_iam_role.k8s_ops_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }


  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = data.aws_codecommit_repository.app_repo.repository_name
        BranchName           = var.repository_branch
        PollForSourceChanges = "false"
      }
      run_order = 1
    }
  }
  stage {
    name = "Build"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.image_build.name
      }
      run_order = 1
    }
    action {
      name            = "Testing"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.image_test.name
      }
      run_order = 2
    }
  }
  dynamic "stage" {
    for_each = var.environments_config
    content {
      name = "${title(stage.value.name)}-Deploy"
      dynamic "action" {
        for_each = stage.value.manual_approval_required ? [1] : []
        content {
          name     = "ManualApproval"
          category = "Approval"
          owner    = "AWS"
          provider = "Manual"
          version  = "1"
          configuration = {
            CustomData = "Please review the changes and approve the deployment"
          }
          run_order = 1
        }
      }
      action {
        name            = "Deploy"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["source_output"]
        version         = "1"
        configuration = {
          ProjectName = module.deployment_phase[stage.value.name].environment_deployment_project_name
        }
        run_order = stage.value.manual_approval_required ? 2 : 1
      }
    }
  }

  depends_on = [
    aws_codebuild_project.image_build,
    aws_codebuild_project.image_test,
    module.deployment_phase,
    aws_iam_policy_attachment.codepipeline_privileges_attachment
  ]
}

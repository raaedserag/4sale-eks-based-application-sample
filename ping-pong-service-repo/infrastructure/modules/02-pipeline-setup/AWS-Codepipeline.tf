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
      run_order = 2
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
      run_order = 3
    }

  }
  stage {
    name = "Staging-Deployment"
    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ProjectName = module.staging_deployment_project.environment_deployment_project_name
      }
      run_order = 4
    }
  }
  #   stage {
  #     name = "ManualApproval"
  #     action {
  #       name     = "ManualApproval"
  #       category = "Approval"
  #       owner    = "AWS"
  #       provider = "Manual"
  #       version  = "1"
  #       configuration = {
  #         CustomData = "Please review the changes and approve the deployment"
  #       }
  #       run_order = 5
  #     }
  #   }
  #   stage {
  #     name = "Production"
  #     action {
  #       name            = "Build"
  #       category        = "Build"
  #       owner           = "AWS"
  #       provider        = "CodeBuild"
  #       input_artifacts = ["source_output"]
  #       version         = "1"
  #       configuration = {
  #         ProjectName = aws_codebuild_project.production_build.name
  #       }
  #       run_order = 6
  #     }
  #     action {
  #       name            = "Deploy"
  #       category        = "Build"
  #       owner           = "AWS"
  #       provider        = "CodeBuild"
  #       input_artifacts = ["source_output"]
  #       version         = "1"
  #       configuration = {
  #         ProjectName = aws_codebuild_project.production_deploy.name
  #       }
  #       run_order = 7
  #     }
  #   }
}

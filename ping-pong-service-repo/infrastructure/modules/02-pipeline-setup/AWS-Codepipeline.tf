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
        ProjectName = aws_codebuild_project.build_phase.name
      }
      run_order = 2
    }
  }
}

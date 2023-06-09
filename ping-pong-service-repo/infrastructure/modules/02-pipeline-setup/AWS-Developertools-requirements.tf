data "aws_iam_role" "k8s_ops_role" {
  name = local.eks_ops_config.cicd_role_name
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "${var.namespace}-${var.app_name}-pipeline-artifacts"
  force_destroy = true
}
resource "aws_cloudwatch_log_group" "codepipeline_log_group" {
  name = "/${var.namespace}/${var.app_name}/pipeline"
}

resource "aws_iam_policy" "codepipeline_privileges" {
  name = "${var.namespace}-${var.app_name}-codepipeline-priviliges"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:*"
        ]
        Effect   = "Allow"
        Resource = "${data.aws_codecommit_repository.app_repo.arn}"
      },
      {
        Action = [
          "ecr:*"
        ]
        Effect = "Allow"
        Resource = [
          var.ecr_repository_arn
        ]
      },
      {
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:Put*",
          "s3:Get*"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.codepipeline_bucket.arn}",
          "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        ]
      },
      {
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect = "Allow"
        Resource = [
          data.aws_secretsmanager_secret_version.eks_ops_config.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "codepipeline_privileges_attachment" {
  name       = "codepipeline_privileges_attachment"
  roles      = [data.aws_iam_role.k8s_ops_role.name]
  policy_arn = aws_iam_policy.codepipeline_privileges.arn
}

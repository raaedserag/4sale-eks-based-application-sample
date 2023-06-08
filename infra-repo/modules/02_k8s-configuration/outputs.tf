resource "aws_secretsmanager_secret" "eks_ops_config" {
  name = "/${var.namespace}/eks-ops-config"
}
resource "aws_secretsmanager_secret_version" "eks_ops_config" {
  secret_id     = aws_secretsmanager_secret.eks_ops_config.id
  secret_string = jsonencode({
    cicd_role_name = aws_iam_role.cicd_role.name
    dockerhub_username = var.dockerhub_username
    dockerhub_password = var.dockerhub_password
  })
}
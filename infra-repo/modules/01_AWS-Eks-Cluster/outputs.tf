output "eks_cluster_config" {
  value = {
    endpoint               = aws_eks_cluster.main_eks.endpoint
    cluster_ca_certificate = aws_eks_cluster.main_eks.certificate_authority[0].data
    name                   = aws_eks_cluster.main_eks.id
    arn                    = aws_eks_cluster.main_eks.arn
  }
}
# Export EKS cluster config to AWS Secrets Manager
resource "aws_secretsmanager_secret" "eks_cluster_config" {
  name = "/${var.namespace}/eks-cluster-config"
}
resource "aws_secretsmanager_secret_version" "eks_cluster_config" {
  secret_id     = aws_secretsmanager_secret.eks_cluster_config.id
  secret_string = jsonencode({
    endpoint               = aws_eks_cluster.main_eks.endpoint
    cluster_ca_certificate = aws_eks_cluster.main_eks.certificate_authority[0].data
    name                   = aws_eks_cluster.main_eks.id
    arn                    = aws_eks_cluster.main_eks.arn
  })
}

output "workernodes_role_arn" {
  value = aws_iam_role.eks_ec2_nodes_service_role.arn
}

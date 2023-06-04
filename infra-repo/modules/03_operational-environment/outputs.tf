resource "aws_secretsmanager_secret" "mysql_config" {
  name = "/${var.namespace}/${var.environment_name}/mysql-config"
}
resource "aws_secretsmanager_secret_version" "mysql_config" {
  secret_id     = aws_secretsmanager_secret.mysql_config.id
  secret_string = jsonencode(local.mysql_config)
}

output "eks_namespace" {
  value = kubernetes_namespace.current_namespace.metadata.0.name
}


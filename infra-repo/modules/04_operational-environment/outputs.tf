# Export MySQL config to AWS Secrets Manager
resource "aws_secretsmanager_secret" "mysql_config" {
  name = "/${var.namespace}/${var.environment_name}/mysql-config"
}
resource "aws_secretsmanager_secret_version" "mysql_config" {
  secret_id     = aws_secretsmanager_secret.mysql_config.id
  secret_string = jsonencode(local.mysql_config)
}


# Export Environment Config to AWS Secrets Manager
resource "aws_secretsmanager_secret" "environment_config" {
  name = "/${var.namespace}/${var.environment_name}/environment-config"
}
resource "aws_secretsmanager_secret_version" "environment_config" {
  secret_id     = aws_secretsmanager_secret.environment_config.id
  secret_string = jsonencode(local.environment_config)
}
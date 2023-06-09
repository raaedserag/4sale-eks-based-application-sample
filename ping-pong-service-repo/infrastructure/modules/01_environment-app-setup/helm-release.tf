data "aws_secretsmanager_secret_version" "environment_config" {
  secret_id = "/${var.namespace}/${var.environment_name}/environment-config"
}


locals {
  environment_config = jsondecode(data.aws_secretsmanager_secret_version.environment_config.secret_string)
  helm_values = {
    "env"              = var.environment_name
    "image.repository" = var.ecr_repository_url
    "image.tag"        = "latest"
  }
}
resource "helm_release" "k8s_app_setup" {
  name      = "${var.app_name}-${var.environment_name}"
  chart     = "../manifest/deployment-chart"
  namespace = local.environment_config.k8s_namespace
  wait      = false

  dynamic "set" {
    for_each = local.helm_values
    content {
      name  = set.key
      value = set.value
    }
  }
}


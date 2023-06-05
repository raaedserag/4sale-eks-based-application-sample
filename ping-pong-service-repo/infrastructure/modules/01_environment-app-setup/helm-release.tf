data "aws_secretsmanager_secret_version" "environment_config" {
  secret_id = "/${var.namespace}/${var.environment_name}/environment-config"
}


locals {
  environment_config = jsondecode(data.aws_secretsmanager_secret_version.environment_config.secret_string)
  helm_values = {
    "customer"    = var.namespace
    "appName"     = var.app_name
    "env"         = var.environment_name
    "namespace"   = local.environment_config.K8S_NAMESPACE_NAME
    "image.repository" = var.app_repository_url
  }
}
resource "helm_release" "k8s_app_setup" {
  name  = var.app_name
  chart = "./deployment-chart"
  wait  = false
  
  dynamic "set" {
    for_each = local.helm_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

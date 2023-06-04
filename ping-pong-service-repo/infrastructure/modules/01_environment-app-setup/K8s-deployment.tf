locals {
  app_dynamic_environment_variables = {
    MYSQL_HOST = {
      secret_name = "mysql-config"
      key       = "MYSQL_HOST"
    }
    MYSQL_PORT = {
      secret_name = "mysql-config"
      key       = "MYSQL_PORT"
    }
    MYSQL_USER = {
      secret_name = "mysql-config"
      key       = "MYSQL_USER"
    }
    MYSQL_PASSWORD = {
      secret_name = "mysql-config"
      key       = "MYSQL_PASSWORD"
    }
    NODE_ENV = {
      secret_name = "environment-config"
      key       = "ENVIRONMENT_NAME"
    }
  }
}


resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name      = var.app_name
    namespace = local.namespace
    labels    = local.app_labels
  }
  spec {
    replicas = var.replicas_count
    selector {
      match_labels = local.app_labels
    }
    min_ready_seconds = 10
    template {
      metadata {
        name      = var.app_name
        namespace = local.namespace
        labels    = local.app_labels
      }
      spec {
        container {
          name = var.app_name
          image = var.app_repository_url
          port {
            name           = "http"
            container_port = 80
          }

          dynamic "env" {
            for_each = var.static_environment_variables
            content {
              name = env.key
              value = env.value

            }
          }
          dynamic "env" {
            for_each = local.app_dynamic_environment_variables
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = env.value.secret_name
                  key  = env.value.key
                }
              }
            }
          }
        }
      }
    }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "50%"
        max_unavailable = "0"
      }
    }
  }
  wait_for_rollout = false
}

resource "kubernetes_namespace" "current_namespace" {
  metadata {
    name = "${var.namespace}-${var.environment_name}"
  }
}

resource "kubernetes_secret" "environment_config" {
  type = "Opaque"
  metadata {
    namespace = kubernetes_namespace.current_namespace.metadata.0.name
    name      = "environment-config"
  }

  data = { for key, value in local.environment_config : key => value }

}
resource "kubernetes_secret" "mysql_config" {
  type = "Opaque"
  metadata {
    namespace = kubernetes_namespace.current_namespace.metadata.0.name
    name      = "mysql-config"
  }

  data = { for key, value in local.mysql_config : key => value }

}

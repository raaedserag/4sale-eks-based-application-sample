resource "kubernetes_service" "app_service" {
  metadata {
    name      = "${var.app_name}-svc"
    namespace = local.namespace
    labels    = local.app_labels
  }
  spec {
    selector = local.app_labels
    type     = "LoadBalancer"
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

  }
}


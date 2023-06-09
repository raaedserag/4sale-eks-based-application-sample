locals {
  service_name = "eks-monitoring"
  namespace    = "monitoring"
}
resource "helm_release" "prometheus_eks_setup" {
  name             = local.service_name
  chart            = "prometheus-community/kube-prometheus-stack"
  version          = "46.8.0"
  namespace        = local.namespace
  create_namespace = true
  cleanup_on_fail  = true
  atomic           = true

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }
}

resource "kubernetes_service" "grafana_external" {
  count = var.enable_public_grafana ? 1 : 0
  metadata {
    name      = "${local.service_name}-grafana-external"
    namespace = local.namespace
    labels = {
      "app.kubernetes.io/name"       = "grafana-external"
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = local.service_name
      "app.kubernetes.io/name"     = "grafana"
    }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
  depends_on = [helm_release.prometheus_eks_setup]
}
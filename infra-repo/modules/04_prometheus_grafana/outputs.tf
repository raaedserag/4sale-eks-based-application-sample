output "grafana_external_address" {
  value = kubernetes_service.grafana_external[0].status.0.load_balancer.0.ingress.0.hostname
}

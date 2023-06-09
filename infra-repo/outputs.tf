output "grafana_external_address" {
    value = "http://${module.eks_prometheus_grafana.grafana_external_address}"
}
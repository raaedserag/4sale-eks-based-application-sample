output "grafana_external_address" {
    value = "http://${module.monitoring.grafana_external_address}"
}
variable "k8s_cluster_config" {
  type = object({
    endpoint               = string
    cluster_ca_certificate = string
    name                   = string
    arn                    = string
  })
  description = "The configuration of your EKS cluster."
}
variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
}
variable "enable_public_grafana" {
  description = "Enable public access to grafana"
  type        = bool
}
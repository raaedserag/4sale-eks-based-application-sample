variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}
variable "vpc_config" {
  description = "VPC configuration"
  type = object({
    cidr_block                  = string
    subnet_public_a_cidr_block  = string
    subnet_public_b_cidr_block  = string
    subnet_private_a_cidr_block = string
    subnet_private_b_cidr_block = string
  })
}
variable "dockerhub_username" {
  description = "Dockerhub username"
  type        = string
}
variable "dockerhub_password" {
  description = "Dockerhub password"
  type        = string
}
variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
}
variable "enable_public_grafana" {
  description = "Enable public access to grafana"
  type        = bool
}
variable "operational_environments" {
  type = list(object({
    name = string
  }))
}

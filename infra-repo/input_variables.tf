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
variable "eks_nodes_config" {
  description = "EKS nodes configuration"
  type = object({
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
      max_unavailable = number
    })
    instance_config = object({
      ami_type       = string
      capacity_type  = string
      disk_size      = number
      instance_types = list(string)
    })
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

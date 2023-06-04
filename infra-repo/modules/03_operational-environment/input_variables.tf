variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}
variable "environment_name"{
  type        = string
  description = "The name of the environment to construct."
}
variable "k8s_cluster_config" {
  type = object({
    endpoint               = string
    cluster_ca_certificate = string
    name                   = string
  })
  description = "The configuration of your EKS cluster."
}

variable "rds_config" {
  type = object({
    vpc_id          = string
    subnets         = list(string)
    allowed_inbound_cidr_blocks = list(string)
  })
  description = "The configuration of the RDS database."
}

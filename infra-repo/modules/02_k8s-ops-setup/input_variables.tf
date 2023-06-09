variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}
variable "k8s_cluster_config" {
  type = object({
    endpoint               = string
    cluster_ca_certificate = string
    name                   = string
    arn                    = string
  })
  description = "The configuration of your EKS cluster."
}
variable "workernodes_role_arn" {
  type        = string
  description = "The ARN of the role that is used by the worker nodes."
}
variable "dockerhub_username" {
  description = "Dockerhub username"
  type        = string
}
variable "dockerhub_password" {
  description = "Dockerhub password"
  type        = string
}
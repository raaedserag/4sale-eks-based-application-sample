variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}
variable "app_name" {
  type        = string
  description = "The name of the application."
}
variable "environment_name" {
  description = "Environment to deploy the application to."
  type        = string
}
variable "ecr_repository_url" {
  type        = string
  description = "The URL of the ECR repository"
}

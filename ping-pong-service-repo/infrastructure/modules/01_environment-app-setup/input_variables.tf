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
variable "app_repository_url" {
  type        = string
  description = "The URL of the application repository."
}
variable "replicas_count" {
  description = "Number of replicas to run for the application"
  type        = number
}
variable "static_environment_variables" {
  description = "Static environment variables to be set for the application"
  type        = map(any)
}


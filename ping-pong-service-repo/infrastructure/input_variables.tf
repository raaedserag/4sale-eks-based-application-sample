variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}
variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "replicas_count" {
  description = "Number of replicas to run for the application"
  type        = number
}
variable "static_environment_variables" {
  description = "Static environment variables to be set for the application"
  type        = map(any)
}
variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}
variable "app_name" {
  type        = string
  description = "The name of the application."
}
variable "ecr_repository_url" {
  type        = string
  description = "The URL of the ECR repository"
}
variable "ecr_repository_arn" {
  type        = string
  description = "The ARN of the ECR repository."
}
variable "codecommit_repo_name" {
  description = "Name of the codecommit repository"
  type        = string
}
variable "repository_branch" {
  type        = string
  description = "The name of the repository branch"
}
# variable "staging_environment_config" {
#   type = object({
#     name                           = string
#     image_repository_url           = string
#     image_repository_arn           = string
#     eks_namespace                  = string
#     deployment_name                = string
#     simple_http_app_container_name = string
#     environment_variables          = map(string)
#   })
#   description = "The configuration of staging environment"
# }
# variable "production_environment_config" {
#   type = object({
#     name                           = string
#     image_repository_url           = string
#     image_repository_arn           = string
#     eks_namespace                  = string
#     deployment_name                = string
#     simple_http_app_container_name = string
#     environment_variables          = map(string)
#   })
#   description = "The configuration of staging environment"
# }

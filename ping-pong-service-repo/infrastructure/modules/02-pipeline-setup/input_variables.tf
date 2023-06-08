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
variable "environments_config" {
  type = list(object({
    name = string
    manual_approval_required = bool
  }))
}

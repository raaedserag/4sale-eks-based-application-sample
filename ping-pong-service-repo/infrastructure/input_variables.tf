variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}
variable "app_name" {
  description = "Name of the application"
  type        = string
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
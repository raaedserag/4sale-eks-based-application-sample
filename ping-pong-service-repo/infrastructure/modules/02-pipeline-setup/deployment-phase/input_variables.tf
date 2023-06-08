variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}
variable "app_name" {
  type        = string
  description = "The name of the application."
}
variable "environment_name" {
  type        = string
  description = "The name of the environment."
}
variable "ecr_repository_url" {
  type        = string
  description = "The URL of the ECR repository"
}
variable "cloudwatch_log_group_name" {
  type        = string
  description = "The name of the CloudWatch log group"
}
variable "pipeline_service_role_arn" {
  type        = string
  description = "The ARN of the pipeline service role"
}
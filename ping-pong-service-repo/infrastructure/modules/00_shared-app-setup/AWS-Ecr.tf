resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.namespace}-${var.app_name}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

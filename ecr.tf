resource "aws_ecr_repository" "terraform" {
  name                 = var.project_name
  image_tag_mutability = var.image_mutability
}

resource "aws_sqs_queue" "terraform" {
  name = var.project_name
}

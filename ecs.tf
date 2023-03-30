resource "aws_ecs_cluster" "terraform" {
  name = var.project_name
}

resource "aws_ecs_capacity_provider" "terraform" {
  name = var.project_name
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.terraform.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "terraform" {
  cluster_name       = aws_ecs_cluster.terraform.name
  capacity_providers = [aws_ecs_capacity_provider.terraform.name]
  depends_on = [
    aws_autoscaling_group.terraform
  ]
  default_capacity_provider_strategy {
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.terraform.name
  }
}

resource "aws_cloudwatch_log_group" "terraform" {
  name = var.project_name
}

resource "aws_ecs_task_definition" "ecs" {
  family             = "${var.project_name}-td"
  execution_role_arn = aws_iam_role.ecs_task.arn
  container_definitions = jsonencode([
    {
      name      = var.project_name
      image     = "${aws_ecr_repository.terraform.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region = var.aws_region
          awslogs-group  = aws_cloudwatch_log_group.terraform.name
        }
      }
    }
  ])
}

resource "aws_ecs_service" "terraform" {
  name            = var.project_name
  cluster         = aws_ecs_cluster.terraform.id
  task_definition = aws_ecs_task_definition.ecs.arn
  desired_count   = var.desired_ecs_task_count
}

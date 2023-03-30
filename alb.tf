resource "aws_lb" "terraform" {
  name                       = "${var.project_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = true
  security_groups            = [aws_security_group.alb.id]
  subnets                    = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_target_group" "ecs" {
  name     = var.project_name
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform.id
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.terraform.arn
  port              = var.app_port
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs.arn
    type             = "forward"
  }
}

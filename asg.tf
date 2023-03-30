resource "aws_launch_configuration" "terraform" {
  iam_instance_profile = aws_iam_instance_profile.container_instance.arn
  image_id             = var.ecs_ami_id
  instance_type        = var.ec2_instance_type
  name                 = var.project_name
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.terraform.name} >> /etc/ecs/ecs.config"
  security_groups      = [aws_security_group.container_instance.id]
}

resource "aws_autoscaling_group" "terraform" {
  name                      = var.project_name
  vpc_zone_identifier       = [for subnet in aws_subnet.private : subnet.id]
  protect_from_scale_in     = true
  desired_capacity          = var.desired_asg_capacity
  max_size                  = var.desired_asg_capacity
  min_size                  = var.desired_asg_capacity
  launch_configuration      = aws_launch_configuration.terraform.name
  health_check_type         = "EC2"
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = var.project_name
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "alb" {
  lb_target_group_arn    = aws_lb_target_group.ecs.arn
  autoscaling_group_name = aws_autoscaling_group.terraform.name
}

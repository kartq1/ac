variable "aws_region" {
  type = string
}

variable "s3_tfstate_name" {
  type = string
}

variable "dynamodb_tflock_name" {
  type = string
}

variable "state_file" {
  type = string
}

variable "project_name" {
  type = string
}

variable "image_mutability" {
  type    = string
  default = "MUTABLE"
}

#VPC
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_cidr_block" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]
}

variable "private_cidr_block" {
  type = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
  ]
}

variable "subnet_count" {
  type = map(string)
  default = {
    public  = 2
    private = 1
  }
}

# ECS
variable "ec2_instance_type" {
  type = string
}

variable "desired_asg_capacity" {
  type    = number
  default = 2
}

variable "desired_ecs_task_count" {
  type    = number
  default = 2
}

variable "ecr_image_tag" {
  type = string
}

variable "ecs_ami_id" {
  type = string
}

variable "app_port" {
  type    = number
  default = 80
}

variable "github_repo" {
  type = string
}

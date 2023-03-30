resource "aws_vpc" "terraform" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = var.project_name
  }
}

data "aws_availability_zones" "available" {}

# Public subnets
resource "aws_subnet" "public" {
  count                   = var.subnet_count.public
  vpc_id                  = aws_vpc.terraform.id
  cidr_block              = var.public_cidr_block[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "terraform" {
  vpc_id = aws_vpc.terraform.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform.id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_count.public
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


# Private subnet
resource "aws_subnet" "private" {
  count                   = var.subnet_count.private
  vpc_id                  = aws_vpc.terraform.id
  cidr_block              = var.private_cidr_block[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
}

resource "aws_eip" "terraform" {
  vpc = "true"
}

resource "aws_nat_gateway" "terraform" {
  allocation_id = aws_eip.terraform.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.terraform.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform.id
  }
}

resource "aws_route_table_association" "private" {
  count          = var.subnet_count.private
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


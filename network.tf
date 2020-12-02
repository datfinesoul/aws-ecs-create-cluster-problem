resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.primary.id
  cidr_block              = local.subnet_cidr
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = local.name
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.primary.id

  tags = {
    Name = local.name
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.primary.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

data "aws_vpc" "primary" {
  tags = {
    Name = "vpc-primary"
  }
}

data "aws_internet_gateway" "primary" {
  filter {
    name = "attachment.vpc-id"
    values = [
      data.aws_vpc.primary.id
    ]
  }
}

locals {
  vpc_cidr    = data.aws_vpc.primary.cidr_block_associations[0].cidr_block
  subnet_cidr = cidrsubnet(data.aws_vpc.primary.cidr_block_associations[0].cidr_block, 9, 127)
}

output "aws_vpc_id" {
  value = data.aws_vpc.primary.id
}
output "aws_vpc_cidr" {
  value = local.vpc_cidr
}
output "aws_subnet_cidr" {
  value = local.subnet_cidr
}

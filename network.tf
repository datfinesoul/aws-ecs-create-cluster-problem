resource "aws_subnet" "public_subnet" {
  vpc_id                  = local.vpc_id
  cidr_block              = local.subnet_cidr
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = local.name
  }
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = {
    Name = local.name
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = local.vpc_igw_id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

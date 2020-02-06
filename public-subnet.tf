resource "aws_subnet" "public" {

  vpc_id = aws_vpc.golden-ami-factory.id

  cidr_block = cidrsubnet(aws_vpc.golden-ami-factory.cidr_block, ceil(log(2 * 2, 2)), 1)

  # availabity_zone = ""
  tags = {
    Name = "golden-ami-factory-public"
  }
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.golden-ami-factory.id

  tags = {
    Name = "golden-ami-factory-public"
  }
}

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "igw" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}
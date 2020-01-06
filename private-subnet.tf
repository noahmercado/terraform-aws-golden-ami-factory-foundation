resource "aws_subnet" "private" {

  vpc_id = aws_vpc.golden-ami-factory.id

  cidr_block = cidrsubnet(aws_vpc.golden-ami-factory.cidr_block, ceil(log(2 * 2, 2)), 0)

  # availabity_zone = ""
}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.golden-ami-factory.id

  tags = {
    Name = "noah-demo-private"
  }
}

resource "aws_route_table_association" "private" {

  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private_nat_gateway" {

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

}

resource "aws_vpc_endpoint" "this" {
  count = length(local.vpc_endpoints)

  vpc_id            = aws_vpc.golden-ami-factory.id
  service_name      = data.aws_vpc_endpoint_service.this[count.index].service_name
  vpc_endpoint_type = data.aws_vpc_endpoint_service.this[count.index].service_type

  private_dns_enabled = data.aws_vpc_endpoint_service.this[count.index].service_type == "Interface" ? true : false
  subnet_ids          = data.aws_vpc_endpoint_service.this[count.index].service_type == "Interface" ? [aws_subnet.private.id] : null
  security_group_ids  = data.aws_vpc_endpoint_service.this[count.index].service_type == "Interface" ? [aws_security_group.this.id] : null

  route_table_ids = data.aws_vpc_endpoint_service.this[count.index].service_type == "Gateway" ? [aws_route_table.private.id] : null
}
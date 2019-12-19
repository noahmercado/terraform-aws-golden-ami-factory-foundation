resource "aws_vpc" "golden-ami-factory" {

  cidr_block = "10.0.0.0/16"

  instance_tenancy               = "default"
  enable_dns_hostnames           = true
  enable_classiclink_dns_support = true

  tags = {
    Name = "noah-demo"
  }

}

resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.golden-ami-factory.id
}

resource "aws_nat_gateway" "this" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_eip" "nat" {
  vpc = true
}
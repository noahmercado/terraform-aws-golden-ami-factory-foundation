/*
  Terraform Module data sources

  ---
  All data sources of the module are defined here.
*/

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc_endpoint_service" "this" {
  count = length(local.vpc_endpoints)

  service = local.vpc_endpoints[count.index]
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
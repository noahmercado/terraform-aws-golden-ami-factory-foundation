/*
  Terraform Module locals

  ---
  All locals that are shared throughout the module are defined here.
  Resource specific locals for logic should be declared alongside (at the top of) the resource definition(s).
*/


locals {

  terraformStandardTags = {
    heritage = "Terraform"
    # module        = local.moduleName
    # moduleVersion = local.moduleVersion
    environment = ""
  }

  vpc_endpoints = ["s3", "ssm", "ssmmessages", "ec2"]

}
/*
  Terraform Module outputs

  ---
  All module outputs are defined here.
*/

output "private_subnet" {
  value = aws_subnet.private
}

output "sns_topic" {
  value = aws_sns_topic.golden-ami-factory
}
/*
  Terraform Module outputs

  ---
  All module outputs are defined here.
*/

output "private_subet" {
  value = aws_subnet.private.id
}
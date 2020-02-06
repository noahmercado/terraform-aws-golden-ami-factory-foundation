/*
  Terraform Module variables

  ---
  All module inputs (parameters/variables) are defined here.
*/

variable "organization_id" {
  description = "The id of AWS Organization to allow to subscribe to GoldenAMI updates via SNS."
  type        = string
  default     = ""
}
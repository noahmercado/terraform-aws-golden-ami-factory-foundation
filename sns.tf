resource "aws_sns_topic" "golden-ami-factory" {
  name              = "golden-ami-factory-image-updates"
  kms_master_key_id = "alias/aws/sns"
}
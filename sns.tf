resource "aws_sns_topic" "golden-ami-factory" {

  name = "golden-ami-factory-image-updates"
  # kms_master_key_id = aws_kms_alias.sns.name

  tags = {

  }
}
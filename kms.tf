/*
  KMS CMK for GoldenAMIFactory logging bucket
*/

resource "aws_kms_key" "logs" {

  description             = "GoldenAMIFactory Log Encyrption"
  deletion_window_in_days = 10

  enable_key_rotation = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "GoldenAMIFactoryLogs",
  "Statement": [{
      "Sid": "Allow VPC Flow Logs to use the key",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "delivery.logs.amazonaws.com"
        ]
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow key administration",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${data.aws_caller_identity.current.arn}"
        ]
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow key read and usage",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": [
        "kms:Describe*",
        "kms:List*",
        "kms:Get*",
        "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

  tags = {
    Name = "golden-ami-factory-logs"
  }
}

resource "aws_kms_alias" "logs" {

  name          = "alias/GoldenAMIFactoryLogging"
  target_key_id = aws_kms_key.logs.key_id
}

/*
  KMS CMK for GoldenAMIFactory SNS topic
*/
# resource "aws_kms_key" "sns" {

#   description             = "GoldenAMIFactory SNS Encryption"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Id": "GoldenAMIFactorySNS",
#   "Statement": [{
#       "Sid": "Allow SNS to use the key",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": [
#           "sns.amazonaws.com"
#         ]
#       },
#       "Action": [
#         "kms:Decrypt",
#         "kms:GenerateDataKey*"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Sid": "Allow key administration",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": [
#           "${data.aws_caller_identity.current.arn}"
#         ]
#       },
#       "Action": [
#         "kms:Create*",
#         "kms:Describe*",
#         "kms:Enable*",
#         "kms:List*",
#         "kms:Put*",
#         "kms:Update*",
#         "kms:Revoke*",
#         "kms:Disable*",
#         "kms:Get*",
#         "kms:Delete*",
#         "kms:TagResource",
#         "kms:UntagResource",
#         "kms:ScheduleKeyDeletion",
#         "kms:CancelKeyDeletion"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Sid": "Allow key read",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": [
#           "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         ]
#       },
#       "Action": [
#         "kms:Describe*",
#         "kms:List*",
#         "kms:Get*"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_kms_alias" "sns" {

#   name          = "alias/GoldenAMIFactorySNS"
#   target_key_id = aws_kms_key.sns.key_id
# }
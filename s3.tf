resource "aws_s3_bucket" "logs" {
  # TODO: dynamic bucket suffix or allow end user to specify bucket name
  bucket = "golden-ami-factory-logging"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.logs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "GoldenAMIFactoryLogs",
  "Statement": [{
      "Sid": "ImageBuilderLogs",
      "Effect": "Allow",
      "Principal": [
        "${aws_iam_role.instance.arn}",
      ],
      "Actions": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.id}/imagebuilder/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    },
    {
      "Sid": "VPCFlowLogs",
      "Effect": "Allow",
      "Principal": [
        "${aws_iam_role.flow-logs.arn}",
      ],
      "Actions": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.id}/vpcflowlogs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    },
    {
      "Sid": "ReadOnly",
      "Effect": "Allow",
      "Principal": [
        "${aws_iam_role.flow-logs.arn}",
      ],
      "Actions": [
        "s3:GetObject",
        "s3:GetBucket",
        "s3:DescribeBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.logs.id}/*",
        "arn:aws:s3:::${aws_s3_bucket.logs.id}"
      ]
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.id}"
    }
  ]
}
POLICY
}
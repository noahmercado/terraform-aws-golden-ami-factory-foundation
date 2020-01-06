resource "aws_s3_bucket" "logs" {

  # TODO: dynamic bucket suffix or allow end user to specify bucket name
  bucket = format("golden-ami-factory-logging-%s", random_id.bucket.hex)
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.logs.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "random_id" "bucket" {

  byte_length = 8
}

resource "aws_s3_bucket_policy" "this" {

  bucket = aws_s3_bucket.logs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "GoldenAMIFactoryLogs",
  "Statement": [
    {
      "Sid": "ImageBuilderLogs",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${aws_iam_role.instance.arn}"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.id}/imagebuilder/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    },
    {
        "Sid": "AWSLogDeliveryWrite",
        "Effect": "Allow",
        "Principal": {
            "Service": "delivery.logs.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.id}/vpcflowlogs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
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
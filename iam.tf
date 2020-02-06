/*
  IAM Role for the image builder instances to assume
*/

resource "aws_iam_role" "instance" {

  name = "GoldenAMIFactoryInstanceRole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "AllowEC2"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "instance" {

  name        = "GoldenAMIFactoryInstancePolicy"
  path        = "/"
  description = "EC2 instance permissions for SSM"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeAssociation",
        "ssm:GetDeployablePatchSnapshotForInstance",
        "ssm:GetDocument",
        "ssm:DescribeDocument",
        "ssm:GetManifest",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:ListAssociations",
        "ssm:ListInstanceAssociations",
        "ssm:PutInventory",
        "ssm:PutComplianceItems",
        "ssm:PutConfigurePackageResult",
        "ssm:UpdateAssociationStatus",
        "ssm:UpdateInstanceAssociationStatus",
        "ssm:UpdateInstanceInformation"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2messages:AcknowledgeMessage",
        "ec2messages:DeleteMessage",
        "ec2messages:FailMessage",
        "ec2messages:GetEndpoint",
        "ec2messages:GetMessages",
        "ec2messages:SendReply"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.build-logs.id}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "imagebuilder:GetComponent"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringEquals": {
          "kms:EncryptionContextKeys": "aws:imagebuilder:arn"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "instance" {

  name       = "GoldenAMIFactoryInstance"
  roles      = [aws_iam_role.instance.name]
  policy_arn = aws_iam_policy.instance.arn
}

resource "aws_iam_instance_profile" "instance" {

  name = "GoldenAMIFactoryInstance"
  role = aws_iam_role.instance.name
}
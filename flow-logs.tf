resource "aws_flow_log" "example" {

  iam_role_arn = aws_iam_role.flow-logs.arn

  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.logs.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.golden-ami-factory.id
}

/*
  IAM Role for the VPC flow logs service to assume
*/

resource "aws_iam_role" "flow-logs" {
  name = "GoldenAMIFactoryFlowLogsRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "AllowVpcFlowLogs"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "flow-logs" {
  name        = "GoldenAMIFactoryFlowLogsPolicy"
  path        = "/"
  description = "Log Delivery Permissions for S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Logs"
      "Action": [
        "logs:CreateLogDelivery",
        "logs:DeleteLogDelivery",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
        ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "S3"
      "Action": [
        "s3:PutObject"
        ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.id}/vpcflowlogs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "flow-logs" {
  name       = "GoldenAMIFactoryFlowLogs"
  roles      = [aws_iam_role.flow-logs.name]
  policy_arn = aws_iam_policy.flow-logs.arn
}

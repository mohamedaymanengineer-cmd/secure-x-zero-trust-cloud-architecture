locals {
  trust_ec2 = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  trust_lambda = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  trust_flowlogs = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowVpcFlowLogsTrust"
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  trust_cloudtrail = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowCloudTrailTrust"
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "ec2_lab" {
  name                 = "${var.prefix}-ec2-lab-role"
  assume_role_policy   = local.trust_ec2
  max_session_duration = 3600
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_lab.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_lab" {
  name = aws_iam_role.ec2_lab.name
  role = aws_iam_role.ec2_lab.name
}

resource "aws_iam_role" "ir_lambda" {
  name               = "${var.prefix}-ir-lambda-role"
  assume_role_policy = local.trust_lambda
}

resource "aws_iam_role_policy_attachment" "ir_lambda_basic" {
  role       = aws_iam_role.ir_lambda.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "vpc_flowlogs" {
  name               = "${var.prefix}-vpc-flowlogs-role"
  assume_role_policy = local.trust_flowlogs
}

resource "aws_iam_role" "audit_cloudtrail" {
  name               = "${var.prefix}-audit-cloudtrail-role"
  assume_role_policy = local.trust_cloudtrail
}

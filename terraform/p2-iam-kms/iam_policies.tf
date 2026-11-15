resource "aws_iam_role_policy" "ec2_workload" {
  name = "${var.prefix}-ec2-workload-policy"
  role = aws_iam_role.ec2_lab.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowListDemoPrefixOnly"
        Effect    = "Allow"
        Action    = "s3:ListBucket"
        Resource  = local.data_bucket_arn
        Condition = { StringLike = { "s3:prefix" = ["demo/*"] } }
      },
      {
        Sid      = "AllowBucketLocation"
        Effect   = "Allow"
        Action   = "s3:GetBucketLocation"
        Resource = local.data_bucket_arn
      },
      {
        Sid      = "AllowDemoPathAccessOnly"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = "${local.data_bucket_arn}/demo/*"
      },
      {
        Sid      = "AllowKmsForEbsAndS3"
        Effect   = "Allow"
        Action   = ["kms:Decrypt", "kms:DescribeKey", "kms:GenerateDataKey*"]
        Resource = aws_kms_key.data.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "ir_containment" {
  name = "${var.prefix}-ir-containment-policy"
  role = aws_iam_role.ir_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2ReadAndContainmentActions"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroups",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:DisassociateIamInstanceProfile"
        ]
        Resource = "*"
      },
      {
        Sid      = "AllowEmergencyDenyOnWorkloadRoleOnly"
        Effect   = "Allow"
        Action   = ["iam:PutRolePolicy"]
        Resource = aws_iam_role.ec2_lab.arn
      },
      {
        Sid      = "AllowPublishAlertsToSNS"
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = local.sns_topic_arn
      },
      {
        Sid      = "AllowReadInstanceProfileAssociation"
        Effect   = "Allow"
        Action   = ["ec2:DescribeIamInstanceProfileAssociations"]
        Resource = "*"
      },
      {
        Sid    = "AllowReadWorkloadProfileAndRole"
        Effect = "Allow"
        Action = ["iam:GetInstanceProfile", "iam:GetRole"]
        Resource = [
          aws_iam_instance_profile.ec2_lab.arn,
          aws_iam_role.ec2_lab.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "vpc_flowlogs" {
  name = "${var.prefix}-vpc-flowlogs-policy"
  role = aws_iam_role.vpc_flowlogs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowPublishToCloudWatchLogs"
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "arn:${local.partition}:logs:${var.region}:${local.account_id}:log-group:${local.flowlogs_log_group}:*"
    }]
  })
}

resource "aws_iam_role_policy" "audit_cloudtrail" {
  name = "${var.prefix}-audit-cloudtrail-policy"
  role = aws_iam_role.audit_cloudtrail.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "AllowCloudTrailLogDelivery"
      Effect   = "Allow"
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Resource = "arn:${local.partition}:logs:${var.region}:${local.account_id}:log-group:${local.cloudtrail_log_group}:*"
    }]
  })
}

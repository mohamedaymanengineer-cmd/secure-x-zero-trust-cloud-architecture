locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition

  data_bucket_name = "${var.prefix}-data-${local.account_id}-${var.suffix}"
  data_bucket_arn  = "arn:${local.partition}:s3:::${local.data_bucket_name}"

  key_admins = length(var.key_admin_arns) > 0 ? var.key_admin_arns : [data.aws_caller_identity.current.arn]

  flowlogs_log_group   = "/aws/${var.prefix}/vpc-flowlogs"
  cloudtrail_log_group = "/aws/${var.prefix}/cloudtrail"

  sns_topic_arn = "arn:${local.partition}:sns:${var.region}:${local.account_id}:${var.prefix}-security-alerts"
}

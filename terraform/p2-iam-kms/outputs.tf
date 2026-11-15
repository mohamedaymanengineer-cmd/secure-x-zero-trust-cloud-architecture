output "kms_key_id" { value = aws_kms_key.data.key_id }
output "kms_key_arn" { value = aws_kms_key.data.arn }
output "kms_alias" { value = aws_kms_alias.data.name }
output "key_admins" { value = local.key_admins }

output "role_arns" {
  value = {
    ec2_lab          = aws_iam_role.ec2_lab.arn
    ir_lambda        = aws_iam_role.ir_lambda.arn
    vpc_flowlogs     = aws_iam_role.vpc_flowlogs.arn
    audit_cloudtrail = aws_iam_role.audit_cloudtrail.arn
  }
}

output "instance_profile_arn" { value = aws_iam_instance_profile.ec2_lab.arn }
output "data_bucket_name" { value = local.data_bucket_name }

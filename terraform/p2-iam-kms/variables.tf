variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "securex"
}

variable "suffix" {
  description = "Bucket name suffix (digit 1, not the letter l)"
  type        = string
  default     = "top1team"
}

variable "key_admin_arns" {
  description = <<-EOT
    IAM user ARNs to set as KMS key administrators.
    If empty, the identity running terraform apply is used.
    Example: ["arn:aws:iam::111122223333:user/Ahmed-Ehab"]
  EOT
  type        = list(string)
  default     = []
}

variable "kms_deletion_window_days" {
  description = "KMS key deletion waiting period in days after destroy (7-30)"
  type        = number
  default     = 7
}

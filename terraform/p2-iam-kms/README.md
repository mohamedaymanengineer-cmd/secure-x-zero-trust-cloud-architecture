# SecureX P2 (IAM & KMS) - Terraform

Terraform version of stage P2, matching handoff v03.1. Built for testing on a personal AWS account.

## What it creates
| Resource | Name |
|---|---|
| KMS key + alias | `alias/securex-data-key` (annual rotation) |
| Key policy | 4 statements: root, key administrators, 2 CloudTrail statements |
| IAM roles | `securex-ec2-lab-role`, `securex-ir-lambda-role`, `securex-vpc-flowlogs-role`, `securex-audit-cloudtrail-role` |
| Instance profile | `securex-ec2-lab-role` |
| Inline policies | workload, containment (5 statements), flow logs, CloudTrail |

## Usage
```bash
aws configure                      # access key of an IAM user (not root)
aws sts get-caller-identity        # confirm the target account
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan                     # expect: 13 to add
terraform apply
terraform output
```

## Cleanup
```bash
terraform destroy
```
The KMS key enters Pending deletion for `kms_deletion_window_days` (default 7) before it is deleted.

## Cost
- KMS key: about USD 1 per month (billed hourly).
- IAM: free.

## Notes
- Do not apply this to the team account (471565333548). The resources already exist there and are managed through the Console; `apply` would fail or create a duplicate KMS key.
- Tags use `ManagedBy=Terraform` instead of `Console`.
- Buckets, the SNS topic and the log groups are not created here (P3 and P5). The policies only reference their names.

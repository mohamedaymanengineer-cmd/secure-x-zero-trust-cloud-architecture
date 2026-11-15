provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "SecureX"
      Environment = "Project"
      Owner       = "P2"
      ManagedBy   = "Terraform"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

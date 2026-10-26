variable "aws_region" {
  description = "AWS region in which to create the remote-state backend."
  type        = string
  default     = "ap-south-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
  default     = "gitops-platform-terraform-locks"
}

variable "tags" {
  description = "Tags applied to state backend resources."
  type        = map(string)
  default     = {
    Project   = "gitops-platform-eks"
    ManagedBy = "Terraform"
  }
}

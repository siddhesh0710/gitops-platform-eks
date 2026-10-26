output "state_bucket_name" {
  description = "S3 bucket to use in the S3 backend configuration."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_lock_table_name" {
  description = "DynamoDB table to use for Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}

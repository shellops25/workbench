output "log_bucket_name" {
  description = "Name of the S3 log bucket"
  value       = aws_s3_bucket.log.id
}

output "log_bucket_arn" {
  description = "ARN of the S3 log bucket"
  value       = aws_s3_bucket.log.arn
}

output "log_bucket_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the log bucket"
  value       = aws_kms_key.log_bucket.arn
}

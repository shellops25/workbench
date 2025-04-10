output "s3_bucket_name" {
  value = aws_s3_bucket.mulesoft_bucket.bucket
}

output "s3_logging_bucket_name" {
  value = aws_s3_bucket.log_bucket.bucket
}

output "iam_role_arn" {
  value = aws_iam_role.mulesoft_assume_role.arn
}

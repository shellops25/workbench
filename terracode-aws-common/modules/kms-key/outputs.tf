output "arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.this.arn
}

output "key_id" {
  description = "The key ID of the KMS key"
  value       = aws_kms_key.this.key_id
}

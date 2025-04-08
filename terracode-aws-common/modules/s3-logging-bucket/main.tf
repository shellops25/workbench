
resource "aws_kms_key" "log_bucket" {
  description             = "KMS key for S3 log bucket encryption"
  enable_key_rotation    = true
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowRootAccount"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "AllowS3"
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action    = [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ]
        Resource = "*"
      },
      {
        Sid       = "AllowS3Logging"
        Effect    = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action    = [
          "kms:GenerateDataKey",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "log_bucket" {
  name          = "alias/${var.bucket_name}-logs-key"
  target_key_id = aws_kms_key.log_bucket.key_id
}

resource "aws_s3_bucket" "log" {
  bucket = "${var.bucket_name}-logs-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"

  force_destroy = false

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.log_bucket.arn
      }
      bucket_key_enabled = true
    }
  }

  ownership_controls {
    rule {
      object_ownership = "ObjectWriter"
    }
  }

  lifecycle_rule {
    enabled = true
    abort_incomplete_multipart_upload_days = 7
  }

  logging {
    target_bucket = aws_s3_bucket.log.id
    target_prefix = "access-logs/"
  }
}

resource "aws_s3_bucket_policy" "log" {
  bucket = aws_s3_bucket.log.id

  policy = data.aws_iam_policy_document.log_bucket.json
}

data "aws_iam_policy_document" "log_bucket" {
  statement {
    sid    = "EnforceSSLOnly"
    effect = "Deny"
    actions = ["s3:*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      aws_s3_bucket.log.arn,
      "${aws_s3_bucket.log.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "AllowS3LoggingService"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.log.arn}/*"]
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


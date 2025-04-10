provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "mulesoft_bucket" {
  bucket = var.bucket_name
}

resource "aws_iam_role" "mulesoft_assume_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = var.mulesoft_service_role_arn
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "mulesoft_s3_policy" {
  name = "mulesoft-s3-access"
  role = aws_iam_role.mulesoft_assume_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.mulesoft_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "mulesoft_bucket_policy" {
  bucket = aws_s3_bucket.mulesoft_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowAccessFromMuleSoft",
        Effect = "Allow",
        Principal = {
          AWS = var.mulesoft_service_role_arn
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "${aws_s3_bucket.mulesoft_bucket.arn}/*",
        Condition = {
          IpAddress = {
            "aws:SourceIp" = var.mulesoft_source_cidrs
          }
        }
      },
      {
        Sid = "AllowAccessFromEC2Instance",
        Effect = "Allow",
        Principal = {
          AWS = var.ec2_instance_role_arn
        },
        Action = "s3:*",
        Resource = [
          aws_s3_bucket.mulesoft_bucket.arn,
          "${aws_s3_bucket.mulesoft_bucket.arn}/*"
        ]
      },
      {
        Sid = "DefaultDeny",
        Effect = "Deny",
        Principal = "*",
        Action = "s3:*",
        Resource = [
          aws_s3_bucket.mulesoft_bucket.arn,
          "${aws_s3_bucket.mulesoft_bucket.arn}/*"
        ],
        Condition = {
          StringNotEqualsIfExists = {
            "aws:PrincipalArn" = [
              var.mulesoft_service_role_arn,
              var.ec2_instance_role_arn
            ]
          }
        }
      }
    ]
  })
}

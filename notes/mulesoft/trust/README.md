
# Create an IAM Role in AWS with a Trust Policy

1. In the AWS Management Console, go to the IAM service and select Roles.
2. Click on Create role and choose Custom trust policy
3. Use the following trust policy, replacing `mulesoft-generated-role-arn` with the ARN provided by MuleSoft:

```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "mulesoft-generated-role-arn"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
```
4. Proceed to the next step without attaching any permissions for now
5. Name the role appropriately (e.g., MuleSoftAccessRole) and create it.
---

## Attach Permissions to the IAM Role:

1. After creating the role, attach the necessary policies that define the permissions MuleSoft applications will have in your AWS account. For example, to grant read-only access to S3 buckets, attach the `AmazonS3ReadOnlyAccess` policy.

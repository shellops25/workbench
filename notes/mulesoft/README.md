
# MuleSoft CloudHub 2.0 to S3 via Private Network Setup

This guide walks through how to configure MuleSoft CloudHub 2.0 Private Spaces to securely access an S3 bucket in your AWS account over AWS's private network using IAM role assumption.

---

## Step 1: CloudHub 2.0 Configuration (MuleSoft Admin)

1. Navigate to **Runtime Manager > Private Spaces**
2. Select your **CH2.0 Private Space**
3. Go to the **Advanced** tab
4. Enable the **AWS Service Role**
   - This generates a role like:
     ```
     arn:aws:iam::<mulesoft-account-id>:role/mulesoft-ch2-role-<region>-<space-id>
     ```
5. Save this role name for the next steps.

---

## Step 2: AWS IAM Configuration 

### 1. Create IAM Role to be Assumed by MuleSoft

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<mulesoft-account-id>:role/mulesoft-ch2-role-<region>-<space-id>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<value-provided-by-mulesoft>"
        }
      }
    }
  ]
}
```

### 2. Attach S3 Permissions to the Role

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
```

### 3. (Optional) Add a Secure S3 Bucket Policy

```json
{
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:*",
  "Resource": [
    "arn:aws:s3:::your-bucket-name",
    "arn:aws:s3:::your-bucket-name/*"
  ],
  "Condition": {
    "StringNotEquals": {
      "aws:PrincipalArn": "arn:aws:iam::<your-account-id>:role/ch2-s3-servicerole-test"
    }
  }
}
```

---

## Step 3: MuleSoft Developer App Configuration

```xml
<s3:config name="Amazon_S3_Configuration2" doc:name="Amazon S3 Configuration" doc:id="d72a7408-a62d-401d-a0a0-314936300bd4">
  <s3:role-connection 
    roleARN="arn:aws:iam::111122223333:role/ch2-s3-servicerole-test"
    accessKey="dummyKey"
    secretKey="dummySecret"
    region="ap-southeast-2"
    tryDefaultAWSCredentialsProviderChain="true" />
</s3:config>
```

- `accessKey` and `secretKey` are dummy values
- `tryDefaultAWSCredentialsProviderChain="true"` enables IAM role assumption from CH2.0
- `region` should match your AWS region

---

## Final Checklist

| Step                      | Owner              | Status |
|---------------------------|--------------------|--------|
| Enable AWS Service Role   | MuleSoft Admin     | ✅      |
| Create IAM Role in AWS    | Your AWS Team      | ✅      |
| Attach S3 Access Policy   | Your AWS Team      | ✅      |
| (Optional) Bucket Policy  | Your AWS Team      | 🔒 Recommended |
| S3 Connector Config       | MuleSoft Developer | ✅      |

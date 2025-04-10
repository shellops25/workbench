
Enabling MuleSoft CloudHub 2.0 to Access AWS S3 via IAM Role
=============================================================

This guide explains how to configure MuleSoft CloudHub 2.0 (CH2.0) Private Space applications to access S3 buckets in your AWS account using AWS IAM roles. This setup avoids the need for PrivateLink by using AWS's native cross-account role assumption.

Scope
-----

Allow MuleSoft CH2.0 applications to write securely to an S3 bucket in your AWS account using an IAM role and the Default AWS Credentials Provider Chain.

Prerequisites
-------------

- MuleSoft application deployed in CloudHub 2.0 Private Space
- MuleSoft Private Space with AWS Service Role feature enabled
- Access to your AWS account to create IAM roles and S3 buckets

Instructions
------------------

1. Enable AWS Service Role in CH2.0 Private Space

- Navigate to Anypoint Platform > Runtime Manager > Private Spaces
- Select your Private Space
- Go to the Advanced tab
- Enable the AWS Service Role
- MuleSoft will generate a unique role ARN, like:

  arn:aws:iam::<mulesoft-account-id>:role/mulesoft-ch2-role-<region>-<space-id>

2. Create IAM Role in Your AWS Account

In your AWS account, create a new IAM role (e.g., ch2-s3-servicerole-test) that MuleSoft can assume.

Trust Policy:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<MuleSoftAccountID>:role/mulesoft-ch2-role-<region>-<space-id>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<provided-by-mulesoft>"
        }
      }
    }
  ]
}

3. Attach S3 Access Policy to the Role

{
  "Effect": "Allow",
  "Action": [
    "s3:PutObject",
    "s3:GetObject"
  ],
  "Resource": "arn:aws:s3:::your-bucket-name/*"
}

4. MuleSoft S3 Connector Configuration (XML)

<s3:config name="Amazon_S3_Configuration2" doc:name="Amazon S3 Configuration">
  <s3:role-connection 
    roleARN="arn:aws:iam::111122223333:role/ch2-s3-servicerole-test"
    accessKey="dummyKey"
    secretKey="dummySecret"
    region="ap-southeast-2"
    tryDefaultAWSCredentialsProviderChain="true" />
</s3:config>

Security Notes
--------------

- This configuration uses cross-account IAM roles for secure, short-lived credential access
- The MuleSoft service role is granted permission to assume your role, and your role is scoped to just your S3 bucket
- No AWS access/secret keys are exposed

Not Supported in CloudHub 1.0
-----------------------------

This method only works with CloudHub 2.0 Private Spaces. It does not apply to CloudHub 1.0 environments.

Summary
-------

| Capability                        | Supported |
|----------------------------------|-----------|
| S3 access via IAM Role           | Yes       |
| PrivateLink to S3                | No        |
| Requires CH2 Private Space       | Yes       |
| Requires AWS IAM role            | Yes       |
| Requires proxy/NLB in VPC        | No        |

Reference
---------

- Salesforce Knowledge Article ID: 001115331
- Published: March 2, 2024
- Link: https://help.salesforce.com/s/articleView?id=001115331&type=1

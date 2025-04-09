# Confluent PrivateLink Network (AWS)

This Terraform configuration provisions a **PrivateLink network** in **Confluent Cloud** for AWS. It uses the Confluent Cloud Terraform provider to automate the initial step of setting up a PrivateLink connection, which is required before provisioning an AWS VPC endpoint.

---

## This Module Does

- Authenticates to Confluent Cloud using API key/secret
- Creates an environment (if one doesn’t exist)
- Creates a PrivateLink network for the specified AWS region

---

## Prerequisites

- A [Confluent Cloud](https://confluent.cloud/) account
- An API key and secret for the **Confluent Management API** (not Kafka API)
- Terraform v1.3+ and Confluent provider `~> 1.57.0`

---

## How to Get Your Confluent API Key/Secret

1. Log into [https://confluent.cloud](https://confluent.cloud)
2. Click on your avatar in the top-right → **"Account & API Keys"**
3. Under the **"API Keys"** tab:
   - Click **"Create Key"**
   - Choose **"Global access"** or a specific environment
   - Select **"Management API"** (not Kafka cluster)
4. Save your **API Key** and **API Secret**

---

## Input Variables

| Name                  | Description                                           | Type     | Required |
|-----------------------|-------------------------------------------------------|----------|----------|
| `confluent_api_key`   | Confluent Cloud API Key                               | `string` | Yes   |
| `confluent_api_secret`| Confluent Cloud API Secret                            | `string` | Yes   |
| `environment_name`    | Name of the Confluent environment to create/use       | `string` | No (default: `"dev"`) |
| `region`              | AWS region to deploy the PrivateLink network in       | `string` | No (default: `"us-west-2"`) |

---

## Outputs

| Name                       | Description                             |
|----------------------------|-----------------------------------------|
| `privatelink_network_id`   | ID of the created PrivateLink network   |
| `privatelink_network_status` | Status of the network (`PROVISIONING`, `READY`, etc.) |

---

## Example Usage

```hcl
module "confluent_privatelink" {
  source = "./"

  confluent_api_key    = var.confluent_api_key
  confluent_api_secret = var.confluent_api_secret
  environment_name     = "dev"
  region               = "us-east-1"
}

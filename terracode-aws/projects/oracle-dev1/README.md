# Reverse PrivateLink for Oracle DNA Access from Confluent Cloud

## Scope

Allow a **Kafka Connector hosted in Confluent Cloud** to securely connect to your **on-prem Oracle DNA database** via:


---

## Prerequisites

- Oracle DNA reachable at **172.16.10.20** via **Direct Connect** from AWS VPC
- Confluent Cloud account and **PrivateLink-capable environment**
- AWS VPC with at least **2 private subnets** in different AZs
- Terraform Enterprise workspace or CLI access

---
## Confluent Cloud → AWS PrivateLink ENI → NLB → Direct Connect → Oracle DNA


## Setup: Terraform Resources

Terraform provisions the following:

| Resource                       | Purpose                              |
|--------------------------------|--------------------------------------|
| `aws_lb`                       | Internal NLB for TCP 1521 (Oracle)   |
| `aws_lb_target_group`          | Forwards traffic to Oracle IP        |
| `aws_lb_listener`              | Listens on TCP 1521 on the NLB       |
| `aws_vpc_endpoint_service`     | Exposes the NLB as a PrivateLink service |
| `aws_lb_target_group_attachment` | Registers Oracle IP as a target    |

---

## Deployment Steps

### 1. Customize Inputs in `terraform.tfvars`

```hcl
vpc_id                = "vpc-xxxxxxxx"
private_subnets       = ["subnet-aaaa", "subnet-bbbb"]
oracle_ip             = "172.16.10.20"
allowed_principal_arn = "arn:aws:iam::<confluent-account-id>:root"

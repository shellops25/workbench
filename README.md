# 🛠️ Workbench

This repository is a curated workspace of Terraform infrastructure, automation scripts, and notes supporting various projects and environments (AWS and Azure).

## 📁 Structure

- `lambda/` – AWS Lambda utilities and deployment logic  
- `notes/mulesoft/` – Notes and configuration for Mulesoft integrations  
- `qualys/` – Resources related to Qualys security tooling  
- `terracode-aws/` – Project * env specific AWS Terraform deployments  
- `terracode-aws-common/` – Reusable AWS Terraform modules  
- `terracode-azure-common/` – Reusable Azure Terraform modules  
- `terracode-azure/projects/` – Project & env specific Azure deployments

## 🚀 Usage

Clone the repo and navigate to the desired directory:

```bash
git clone https://github.com/shellops25/workbench.git
cd workbench/terracode-${something}/projects/project
# look/review before you tango
terraform init
terraform plan
terraform apply

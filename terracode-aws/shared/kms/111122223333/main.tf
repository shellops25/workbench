terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

locals {
  kms_mulesoft_dev_tags = {
    env     = "dev"
    account = "111122223333"
    project = "mulesoft"
  }
}

module "kms_mulesoft_dev" {
  source = "git::ssh://git@github.com/shellops25/terracode-aws-common.git//modules/kms-key"
  alias  = "kms-app-mulesoft-dev"
  tags   = local.kms_mulesoft_dev_tags
}

locals {
  kms_mulesoft_prod_tags = {
    env     = "prod"
    account = "111122223333"
    project = "mulesoft"
  }
}

module "kms_mulesoft_prod" {
  source = "git::ssh://git@github.com/shellops25/terracode-aws-common.git//modules/kms-key"
  alias  = "kms-app-mulesoft-prod"
  tags   = local.kms_mulesoft_prod_tags
}

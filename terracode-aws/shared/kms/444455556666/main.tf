terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

locals {
  kms_nextapp1_dev_tags = {
    env     = "dev"
    account = "444455556666"
    project = "nextapp1"
  }
}

module "kms_nextapp1_dev" {
  source = "git::ssh://git@github.com/shellops25/terracode-aws-common.git//modules/kms-key"
  alias  = "kms-app-nextapp1-dev"
  tags   = local.kms_nextapp1_dev_tags
}

locals {
  kms_nextapp1_prod_tags = {
    env     = "prod"
    account = "444455556666"
    project = "nextapp1"
  }
}

module "kms_nextapp1_prod" {
  source = "git::ssh://git@github.com/shellops25/terracode-aws-common.git//modules/kms-key"
  alias  = "kms-app-nextapp1-prod"
  tags   = local.kms_nextapp1_prod_tags
}

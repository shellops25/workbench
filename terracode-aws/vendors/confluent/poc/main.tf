terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 1.57.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_api_key
  cloud_api_secret = var.confluent_api_secret
}

resource "confluent_environment" "env" {
  display_name = var.environment_name
}

resource "confluent_network" "privatelink" {
  display_name     = "aws-privatelink-network"
  cloud            = "AWS"
  region           = var.region
  connection_type  = "PRIVATELINK"

  environment {
    id = confluent_environment.env.id
  }
}

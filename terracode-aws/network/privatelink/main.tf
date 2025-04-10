provider "aws" {
  region = "us-east-1" # change to your region
}

# Variables (replace with actual IDs)
variable "vpc_id" {
  default = "vpc-xxxxxxxxxxxxxxxxx"
}

variable "subnet_ids" {
  default = ["subnet-aaaaaaaaaaaaaaa", "subnet-bbbbbbbbbbbbbbb"]
}

variable "confluent_service_name" {
  description = "Confluent PrivateLink service name"
  default     = "com.amazonaws.vpce.us-east-1.vpce-svc-xxxxxxxxxxxxxxxx"
}

# Security group for the endpoint
resource "aws_security_group" "privatelink_sg" {
  name        = "confluent-privatelink-sg"
  description = "Security group for Confluent PrivateLink"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Tighten this if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Interface Endpoint
resource "aws_vpc_endpoint" "confluent_privatelink" {
  vpc_id            = var.vpc_id
  service_name      = var.confluent_service_name
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = [
    aws_security_group.privatelink_sg.id
  ]

  private_dns_enabled = false # Must be false for Confluent endpoints

  tags = {
    Name = "ConfluentPrivateLinkEndpoint"
  }
}

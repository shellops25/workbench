provider "aws" {
  region = "us-west-2"
}

# Variables (replace with actual IDs)
variable "vpc_id" {
  default = "vpc-xxxxxxxxxxxxxxxxx"
}

variable "subnet_ids" {
  default = ["subnet-a, "subnet-b"]
}

variable "confluent_service_name" {
  description = "Confluent PrivateLink service name"
  default     = "com.amazonaws.vpce.us-east-1.vpce-svc-x"
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
    cidr_blocks = ["0.0.0.0/0"] 
#  cidr_blocks = ["192.168.1.0/24", "10.2.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
#   cidr_blocks = ["192.168.1.0/24", "10.2.1.0/24"]
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

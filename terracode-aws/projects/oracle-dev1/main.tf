
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

resource "aws_lb" "oracle_nlb" {
  name               = "oracle-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnets
}

resource "aws_lb_target_group" "oracle_tg" {
  name        = "oracle-tg"
  port        = 1521
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "oracle_target" {
  target_group_arn = aws_lb_target_group.oracle_tg.arn
  target_id        = var.oracle_ip
  port             = 1521
}

resource "aws_lb_listener" "oracle_listener" {
  load_balancer_arn = aws_lb.oracle_nlb.arn
  port              = 1521
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.oracle_tg.arn
  }
}

resource "aws_vpc_endpoint_service" "oracle" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.oracle_nlb.arn]
  allowed_principals         = [var.allowed_principal_arn]
}

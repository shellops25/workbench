
output "vpc_endpoint_service_name" {
  description = "The service name to give to Confluent Cloud"
  value       = aws_vpc_endpoint_service.oracle.service_name
}

output "nlb_dns_name" {
  description = "The DNS name of the internal NLB"
  value       = aws_lb.oracle_nlb.dns_name
}

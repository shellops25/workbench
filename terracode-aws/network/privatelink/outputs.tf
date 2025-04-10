output "vpc_endpoint_id" {
  value = aws_vpc_endpoint.confluent_privatelink.id
  description = "ID of the VPC endpoint"
}

output "vpc_endpoint_network_interface_ids" {
  value = aws_vpc_endpoint.confluent_privatelink.network_interface_ids
  description = "List of ENI IDs associated with the VPC endpoint"
}

output "vpc_endpoint_private_ips" {
  value = [
    for eni_id in aws_vpc_endpoint.confluent_privatelink.network_interface_ids :
    data.aws_network_interface.eni_info[eni_id].private_ip
  ]
  description = "Private IPs assigned to the ENIs"
}

# You need to fetch info about each ENI
data "aws_network_interface" "eni_info" {
  for_each = toset(aws_vpc_endpoint.confluent_privatelink.network_interface_ids)
  id       = each.key
}

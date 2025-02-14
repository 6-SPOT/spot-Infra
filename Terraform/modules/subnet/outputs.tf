output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.subnet[*].id
}

output "subnet_availability_zones" {
  description = "List of availability zones for the subnets"
  value       = aws_subnet.subnet[*].availability_zone
}
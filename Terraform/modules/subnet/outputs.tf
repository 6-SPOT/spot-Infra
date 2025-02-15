output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.subnet[*].id
}

output "subnet_cidrs" {
  description = "List of subnet cidr"
  value = aws_subnet.subnet[*].cidr_block
}
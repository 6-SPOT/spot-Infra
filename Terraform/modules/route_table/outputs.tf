output "route_table_id" {
  description = "ID of the route table"
  value       = aws_route_table.rt.id
}

output "route_table_ids" {
  description = "List of route table IDs (always a single element)"
  value       = [aws_route_table.rt.id]
}
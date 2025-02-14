variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "gateway_id" {
  description = "Internet Gateway ID for public route table"
  type        = string
  default     = null
}

variable "nat_gateway_id" {
  description = "NAT Gateway ID for private route table"
  type        = string
  default     = null
}

variable "name" {
  description = "Name for the route table"
  type        = string
}

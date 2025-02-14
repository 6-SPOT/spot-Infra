variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "name" {
  description = "Name for the internet gateway"
  type        = string
  default     = "default-igw"
}

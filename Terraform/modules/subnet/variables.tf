variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "name" {
  description = "Name prefix for subnets"
  type        = string
  default     = "default-subnet"
}

variable "public" {
  description = "Indicates if the subnets are public"
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Additional tags to apply to the subnets"
  type        = map(string)
  default     = {}
}

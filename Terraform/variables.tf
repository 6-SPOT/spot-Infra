variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/24"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "my"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_name" {
  description = "Name prefix for public subnets"
  type        = string
  default     = "my-public-subnet"
}

### sg
variable "sg_description" {
  description = "The description of the security group"
  type        = string
  default     = "testnet Security group"
}

variable "sg_ingress_rules" {
  description = "Ingress rules for the security group"
  type = list(object({
    id               = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []
}

variable "sg_egress_rules" {
  description = "Egress rules for the security group"
  type = list(object({
    id               = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []
}

### IAM
variable "ec2_role_name" {}
variable "ec2_policy_name" {}
variable "ec2_instance_profile_name" {}
variable "ec2_policy_statements" {
  type = list(object({
    Effect   = string
    Action   = list(string) 
    Resource = string
  }))
}

variable "codedeploy_role_name" {}
variable "codedeploy_policy_name" {}
variable "codedeploy_policy_statements" {
  type = list(object({
    Effect   = string
    Action   = list(string)  
    Resource = string
  }))
}

variable "codepipeline_role_name" {}
variable "codepipeline_policy_name" {}
variable "codepipeline_policy_statements" {
  type = list(object({
    Effect   = string
    Action   = list(string)  
    Resource = string
  }))
}






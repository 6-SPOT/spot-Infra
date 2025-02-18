### testnet
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
variable "sg_configs" {
  description = "Security group configurations for different environments"
  type = map(object({
    description = string
    ingress_rules = list(object({
      id               = string
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      id               = string
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
  }))
}

variable "sg_description" {
  description = "The description of the security group"
  type        = string
  default     = "testnet Security group"
}

variable "sg_ingress_rules_infra" {
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

variable "sg_egress_rules_infra" {
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

variable "sg_ingress_rules_server" {
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

variable "sg_egress_rules_server" {
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

### EC2
variable "ec2_name" {
  description = "ec2의 이름"
  type        = list(string)
  default     = ["my_ec2"]
}

variable "instance_type" {
  description = "인스턴스 유형, ec2 갯수만큼 넣어줘야함"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "key_name" {
  description = "ssh용 키"
  type        = string
  default     = "test.pem"
}

variable "subnet_id" {
  description = "ec2 생성될 subnet위치"
  type        = string
}

variable "private_ip" {
  description = "ec2에 지정할 프라이빗 ip"
  type        = list(string)
}

### ECR
variable "ecr_repositories" {
  description = "List of ECR repositories to create"
  type        = map(string)
  default = {
    "" = ""
  }
}

### S3
variable "s3_configs" {
  description = "Configurations for multiple S3 buckets"
  type = map(object({
    bucket_name = string
    versioning  = bool
    encryption  = bool
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  }))
}

### Route53
variable "aws_region" {
  default = "ap-northeast-2"
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "domain_mappings" {
  description = "List of domains that need to be linked to EC2 instances"
  type        = map(object({
    subdomain  = string
  }))
}
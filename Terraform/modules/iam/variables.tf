variable "role_name" {
  description = "IAM Role 이름"
  type        = string
}

variable "policy_name" {
  description = "IAM Policy 이름"
  type        = string
}

variable "assume_role_service" {
  description = "이 Role을 사용할 AWS 서비스 (예: ec2.amazonaws.com, codedeploy.amazonaws.com)"
  type        = string
}

variable "policy_statements" {
  description = "IAM Policy JSON 형식의 리스트 (Effect, Action, Resource 포함)"
  type = list(object({
    Effect   = string
    Action   = list(string)  # 여러 개의 액션을 리스트로 받을 수 있도록 설정
    Resource = string
  }))
}

variable "create_instance_profile" {
  description = "EC2의 Instance Profile을 생성할지 여부"
  type        = bool
  default     = false
}

variable "instance_profile_name" {
  description = "EC2 Instance Profile 이름"
  type        = string
  default     = ""
}
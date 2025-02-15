variable "iam_role" {
  description = "ec2가 받아야할 iam role"
  type        = string
}

variable "iam_instance_profile" {
  description = "role을 만들때 생성된 인스턴스 프로파일"
  type        = string
}

variable "ec2_name" {
  description = "ec2 이름 3개"
  type        = list(string)
}

variable "instance_type" {
  description = "인스턴스 유형, ec2 갯수만큼 넣어줘야함"
  type        = list(string)
}

variable "key_name" {
  description = "ssh용 키"
  type        = string
}

variable "subnet_id" {
  description = "ec2 생성될 subnet위치"
  type        = string
}

variable "ami" {
  description = "운영체제 선택"
  type        = string
}

variable "private_ip" {
  description = "프라이빗 ip 지정"
  type        = list(string)
}

variable "sg_ids" {
  description = "붙여야할 sg그룹"
  type        = map(string)
}

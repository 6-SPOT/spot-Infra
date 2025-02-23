output "ec2_mapped_by_name" {
  description = "각 EC2 인스턴스를 Name 태그를 기준으로 매핑"
  value = {
    for idx, instance in module.ec2 : instance.tags_all["Name"] => {
      id         = instance.id
      private_ip = instance.private_ip
      public_ip  = instance.public_ip
      arn        = instance.arn
      ebs_id     = instance.root_block_device
    }
  }
}

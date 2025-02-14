output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "ec2_role_arn" {
  value = module.iam_ec2.role_arn
}

output "ec2_instance_profile_name" {
  value = module.iam_ec2.instance_profile_name
}

output "codedeploy_role_arn" {
  value = module.iam_codedeploy.role_arn
}

output "codepipeline_role_arn" {
  value = module.iam_codepipeline.role_arn
}
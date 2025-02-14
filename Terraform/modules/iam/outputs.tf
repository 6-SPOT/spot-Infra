output "role_arn" {
  value = aws_iam_role.role.arn
}

output "instance_profile_name" {
  value = length(aws_iam_instance_profile.instance_profile) > 0 ? aws_iam_instance_profile.instance_profile[0].name : ""
}
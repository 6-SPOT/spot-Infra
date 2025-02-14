resource "aws_iam_role" "role" {
  name = "testnet-${var.role_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = var.assume_role_service }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "policy" {
  name = "testnet-${var.policy_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = var.policy_statements
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.instance_profile_name
  role  = aws_iam_role.role.name
}
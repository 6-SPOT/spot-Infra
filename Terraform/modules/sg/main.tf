resource "aws_security_group" "sg" {
  name        = "testnet-${var.name}-sg"
  description = var.description
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "inbound" {
  for_each = { for rule in var.ingress_rules : rule.id => rule }

  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  ipv6_cidr_blocks  = each.value.ipv6_cidr_blocks
}

resource "aws_security_group_rule" "outbound" {
  for_each = { for rule in var.egress_rules : rule.id => rule }

  security_group_id = aws_security_group.sg.id
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  ipv6_cidr_blocks  = each.value.ipv6_cidr_blocks
}

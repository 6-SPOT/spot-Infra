resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-rt"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"

  # 조건부로 NAT Gateway 또는 Internet Gateway 설정
  gateway_id     = var.gateway_id != null ? var.gateway_id : null
  nat_gateway_id = var.nat_gateway_id != null ? var.nat_gateway_id : null
}

resource "aws_route_table_association" "association" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.rt.id
}

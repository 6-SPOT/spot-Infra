resource "aws_route53_record" "infra_record" {
  zone_id = var.hosted_zone_id
  name    = var.subdomain
  type    = "A"
  ttl     = 300
  records = [var.public_ip]
}
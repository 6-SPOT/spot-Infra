variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "subdomain" {
  description = "Subdomain to be mapped"
  type        = string
}

variable "public_ip" {
  description = "Public IP to associate with the domain"
  type        = string
}
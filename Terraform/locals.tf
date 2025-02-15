locals {
  public_subnet_cidrs = var.public_subnet_cidrs

  sg_configs = {
    for key, sg in var.sg_configs : key => merge(sg, {
      ingress_rules = [
        for rule in sg.ingress_rules : merge(rule, {
          cidr_blocks = length(rule.cidr_blocks) > 0 ? rule.cidr_blocks : local.public_subnet_cidrs
        })
      ]
    })
  }
}

locals {
  sg_ids = { for k, v in module.sg : k => v.sg_id }
}

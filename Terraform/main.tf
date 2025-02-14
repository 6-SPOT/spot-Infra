module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name       = var.name
}

module "public_subnets" {
  source             = "./modules/subnet"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.public_subnet_cidrs
  availability_zones = var.availability_zones
  name               = var.public_subnet_name
  public             = true
  additional_tags = {
    "kubernetes.io/role/elb"                     = "1"
    "kubernetes.io/cluster/dododocs-eks-cluster" = "shared"
  }
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
  name   = var.name
}

module "route_table_public" {
  source         = "./modules/route_table"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.public_subnets.subnet_ids
  gateway_id     = module.igw.igw_id
  nat_gateway_id = null
  name           = var.name 
}

module "sg" {
  source      = "./modules/sg"
  name        = var.name
  description = var.sg_description
  vpc_id      = module.vpc.vpc_id
  ingress_rules = var.sg_ingress_rules
  egress_rules  = var.sg_egress_rules
}

module "iam_ec2" {
  source                 = "./modules/iam"
  role_name              = var.ec2_role_name
  policy_name            = var.ec2_policy_name
  assume_role_service    = "ec2.amazonaws.com"
  create_instance_profile = true
  instance_profile_name   = var.ec2_instance_profile_name
  policy_statements      = var.ec2_policy_statements
}

module "iam_codedeploy" {
  source              = "./modules/iam"
  role_name           = var.codedeploy_role_name
  policy_name         = var.codedeploy_policy_name
  assume_role_service = "codedeploy.amazonaws.com"
  policy_statements   = var.codedeploy_policy_statements
}

module "iam_codepipeline" {
  source              = "./modules/iam"
  role_name           = var.codepipeline_role_name
  policy_name         = var.codepipeline_policy_name
  assume_role_service = "codepipeline.amazonaws.com"
  policy_statements   = var.codepipeline_policy_statements
}

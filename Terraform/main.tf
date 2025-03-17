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
}

module "private_subnets" {
  source             = "./modules/subnet"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.private_subnet_cidrs
  availability_zones = var.availability_zones_private
  name               = var.private_subnet_name
  public             = true
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

module "route_table_private" {
  source         = "./modules/route_table"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.private_subnets.subnet_ids
  gateway_id     = module.igw.igw_id
  nat_gateway_id = null
  name           = var.name
}


module "iam_ec2" {
  source                  = "./modules/iam"
  role_name               = var.ec2_role_name
  policy_name             = var.ec2_policy_name
  assume_role_service     = "ec2.amazonaws.com"
  create_instance_profile = true
  instance_profile_name   = var.ec2_instance_profile_name
  policy_statements       = var.ec2_policy_statements
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

module "sg" {
  source = "./modules/sg"

  for_each      = local.sg_configs
  name          = each.key
  description   = each.value.description
  vpc_id        = module.vpc.vpc_id
  ingress_rules = each.value.ingress_rules
  egress_rules  = each.value.egress_rules
}

module "ec2" {
  source               = "./modules/ec2"
  iam_role             = module.iam_ec2.role_arn
  iam_instance_profile = module.iam_ec2.instance_profile_name
  ec2_name             = var.ec2_name
  instance_type        = var.instance_type
  key_name             = var.key_name
  subnet_id            = module.public_subnets.subnet_ids[0]
  ami                  = "ami-0077297a838d6761d"
  private_ip           = var.private_ip
  sg_ids               = local.sg_ids
  ec2_tags             = var.ec2_tags
}

resource "aws_ecr_repository" "foo" {
  for_each             = var.ecr_repositories
  name                 = each.value
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

module "s3" {
  source = "./modules/s3"

  for_each = var.s3_configs

  bucket_name             = each.value.bucket_name
  versioning              = each.value.versioning
  encryption              = each.value.encryption
  block_public_acls       = each.value.block_public_acls
  block_public_policy     = each.value.block_public_policy
  ignore_public_acls      = each.value.ignore_public_acls
  restrict_public_buckets = each.value.restrict_public_buckets
}

module "route53" {
  for_each       = var.domain_mappings
  source         = "./modules/route53"
  hosted_zone_id = var.hosted_zone_id
  subdomain      = each.value.subdomain
  public_ip      = local.infra_public_ip
}


module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "6.10.0"
  identifier = "test-db"

  engine            = "mysql"
  engine_version    = "8.4.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name                     = "spotdb"
  username                    = "user"
  password                    = var.db_passwd
  port                        = "3306"
  publicly_accessible         = true
  manage_master_user_password = false

  multi_az                            = false
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = local.sg_id_list

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = local.all_subnet_ids

  # DB parameter group
  family = "mysql8.4"

  # DB option group
  major_engine_version = "8.4"
}

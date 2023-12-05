# CREATE VPC SUBNETS etc
module "vpc" {
  source = "./modules/vpc"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  azs                 = var.azs
}

# CREATE SECURITY GROUPS AND RULES
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

# CREATE LIGHTING SERVER AND DB
module "lighting" {
  source = "./modules/lighting"

  project_name       = var.project_name
  key_name           = var.key_name
  security_group_ids = module.security.security_group_ids
  lighting_subnet_id = module.vpc.pub_sub_ids[0]
}

# CREATE HEATING SERVER AND DB
module "heating" {
  source = "./modules/heating"

  project_name       = var.project_name
  key_name           = var.key_name
  security_group_ids = module.security.security_group_ids
  heating_subnet_id  = module.vpc.pub_sub_ids[0]
}

# CREATE STATUS SERVER
module "status" {
  source = "./modules/status"

  project_name = var.project_name
  key_name = var.key_name
  security_group_ids = module.security.security_group_ids
  status_subnet_id = module.vpc.pub_sub_ids[0]
}
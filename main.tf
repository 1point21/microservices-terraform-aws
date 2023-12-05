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

  project_name       = var.project_name
  key_name           = var.key_name
  security_group_ids = module.security.security_group_ids
  status_subnet_id   = module.vpc.pub_sub_ids[0]
}

# CREATE LOAD BALANCER
module "lb" {
  source = "./modules/loadbalancer"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.pub_sub_ids
  status_ec2_id     = module.status.ec2_status.id
  heating_ec2_id    = module.heating.ec2_heating.id
  lights_ec2_id     = module.lighting.ec2.id
  lb_sec_group_sgs  = module.security.lb_security_group_ids
}
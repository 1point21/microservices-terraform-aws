# CREATE VPC SUBNETS etc
module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
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

# CREATE SERVERS
module "servers" {
  source = "./modules/server"

  project_name       = var.project_name
  services           = var.services
  key_name           = var.key_name
  subnet_id          = module.vpc.pub_sub_ids[0]
  security_group_ids = module.security.security_group_ids
}

# CREATE DATABASES
module "databases" {
  source = "./modules/database"

  services     = var.services
  project_name = var.project_name
}

# CREATE LOAD BALANCER
module "lb" {
  source = "./modules/loadbalancer"

  project_name      = var.project_name
  services          = var.services
  vpc_id            = module.vpc.vpc_id
  ec2_ids           = module.servers.ec2_ids
  public_subnet_ids = module.vpc.pub_sub_ids
  lb_sec_group_sgs  = module.security.lb_security_group_ids
}

# CREATE AUTOSCALE
module "autoscale" {
  source = "./modules/autoscaling"

  project_name             = var.project_name
  services                 = var.services
  key_name                 = var.key_name
  min_size                 = var.min_size
  max_size                 = var.max_size
  desired_size             = var.desired_size
  autoscale_public_subnets = module.vpc.asg_pub_subs
  security_group_ids       = module.security.security_group_ids
  tg_arns                  = module.lb.target_arns
  ec2_ids                  = module.servers.ec2_ids

}




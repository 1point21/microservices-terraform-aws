# PROJECT
project_name = "project-name"
services     = ["status", "service1", "service2"]

# VPC
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
azs                 = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

# INSTANCES
key_name = "ssh-key"

# AUTOSCALING
min_size     = 1
max_size     = 3
desired_size = 2    
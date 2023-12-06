# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type        = string
}

variable "services" {
  description = "list of the services to be deployed"
  type        = list(string)
}

# LB VARIABLES
variable "vpc_id" {
  description = "id of the main vpc"
  type        = string
}

variable "ec2_ids" {
  description = "list of the ids of the servers created, in order as services passed in"
  type        = list(string)
}

variable "lb_sec_group_sgs" {
  description = "list of the ids of the security groups applicable to the load balancer"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "list of the ids of the public subnets"
  type        = list(string)
}
# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type        = string
}

# LB VARIABLES
variable "vpc_id" {
  description = "id of the main vpc"
  type        = string
}

variable "status_ec2_id" {
  description = "id of the ec2 hosting the status server"
  type        = string
}

variable "lights_ec2_id" {
  description = "id of the ec2 hosting the lights server"
  type        = string
}

variable "heating_ec2_id" {
  description = "id of the ec2 hosting the heating server"
  type        = string
}

variable "lb_sec_group_sgs" {
  description = "list of the ids of the security groups applicable to the load balancer"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "list of the ids of the public subnets"
  type        = list(string)
}
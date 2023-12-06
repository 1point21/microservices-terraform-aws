# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type        = string
}

variable "services" {
  description = "list of the services to be deployed"
  type = list(string)
}

# ASG VARIABLES
variable "key_name" {
  description = "name of the key pair for ssh access to instances"
  type        = string
}

variable "ec2_ids" {
  description = "list of the ids of the ec2s according to service"
  type = list(string)
}

variable "security_group_ids" {
    description = "list of the ids for the security groups to apply to the new ec2 servers"
    type = list(string)
}

variable "min_size" {
  description = "minimum size of the autoscaling group"
  type = number
}

variable "max_size" {
  description = "maximum size of the autoscaling group"
  type = number
}

variable "desired_size" {
  description = "desired size of the autoscaling group"
  type = number
}

variable "autoscale_public_subnets" {
    description = "public subnets to autoscale into"
    type = list(string)
}

variable "tg_arns" {
  description = "list of arns of the created target groups"
  type = list(string)
}
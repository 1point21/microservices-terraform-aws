# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type        = string
}

variable "key_name" {
  description = "name of the key pair for ssh access to ec2"
  type        = string
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

# AUTOSCALING VARIABLES
#STATUS
variable "status_ec2_id" {
  description = "id of the ec2 hosting the status server"
  type        = string
}

variable "status_tg_arn" {
  description = "arn of the target group for the status apps"
  type = string
}

#LIGHTS
variable "lights_ec2_id" {
  description = "id of the ec2 hosting the lights server"
  type        = string
}

variable "lights_tg_arn" {
  description = "arn of the target group for the lights apps"
  type = string
}

#HEATING
variable "heating_ec2_id" {
  description = "id of the ec2 hosting the heating server"
  type        = string
}

variable "heating_tg_arn" {
  description = "arn of the target group for the heating apps"
  type = string
}
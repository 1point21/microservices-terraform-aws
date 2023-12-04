# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type = string
}

# INSTANCE VARIABLES
variable "key_name" {
  description = "name of the key pair for ssh access to ec2"
  type = string
}

variable "security_group_ids" {
  description = "a list of strings of the ids of the security groups"
  type = list(string)
}

variable "lighting_subnet_id" {
  description = "id of the subnet the lighting instance should be launched into"
  type = string
}

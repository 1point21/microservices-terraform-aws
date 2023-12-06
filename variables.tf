# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type        = string
}

variable "services" {
  description = "a list of the services to be created"
  type        = list(string)
}

# VPC VARIABLES
variable "vpc_cidr" {
  description = "cidr block value for the main vpc"
  type        = string
}

variable "public_subnet_cidr" {
  description = "list of strings of cidr block ranges for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "list of strings of the cidr block ranges for private subnets"
  type        = list(string)
}

variable "azs" {
  description = "list of strings of the availability zones for subnet creation"
  type        = list(string)
}

# INSTANCE VARIABLES
variable "key_name" {
  description = "name of the key pair for ssh access to ec2"
  type        = string
}


#AUTO-SCALE VARIABLES
variable "min_size" {
  description = "minimum size of the autoscaling group"
  type        = number
}

variable "max_size" {
  description = "maximum size of the autoscaling group"
  type        = number
}

variable "desired_size" {
  description = "desired size of the autoscaling group"
  type        = number
}

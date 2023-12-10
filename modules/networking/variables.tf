# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type        = string
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


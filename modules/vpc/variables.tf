# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type = string
}

# VPC VARIABLES
variable "vpc_cidr" {
  description = "cidr block value for the main vpc"
  type = string
}
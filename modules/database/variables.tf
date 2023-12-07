# PROJECT VARIABLES
variable "project_name" {
  description = "name of the overall project"
  type        = string
}

variable "services" {
  description = "list of the services to be deployed"
  type        = list(string)
}

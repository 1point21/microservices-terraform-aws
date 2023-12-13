## Comment in and add details to use with Terraform Cloud

# terraform {
#   cloud {
#     organization = "example_corp"
#     ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
#     hostname = "app.terraform.io"

#     workspaces {
#       tags = ["app"]
#     }
#   }
# }
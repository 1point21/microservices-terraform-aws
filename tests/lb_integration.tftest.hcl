# run "integration between lb and other modules" {
    
#     # check that target groups have servers"
#     assert {
#     condition     = alltrue([for group in module.loadbalancer.target_groups: group.])
#      error_message = "One or more security groups have not been added to the VPC"
#    }

#     # check that all servers are in a public subnet
#     assert {
#         condition = alltrue()
#         error_message = "One or more public subnets have not been added to the route table"
#     }
# }
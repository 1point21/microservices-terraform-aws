run "integration between vpc and other modules" {
    command = apply
    # check that all security groups are attached to correct vpc
    assert {
    condition     = alltrue([for group in module.security.security_groups: group.vpc_id == module.vpc.vpc_id])
     error_message = "One or more security groups have not been added to the VPC"
   }

    # check that all servers are in a public subnet
    assert {
        condition = alltrue([for server in module.server.servers: contains(module.vpc.pub_sub_ids, server.subnet_id)])
        error_message = "One or more public subnets have not been added to the route table"
    }
}
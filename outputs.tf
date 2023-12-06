output "servers" {
  description = "a list of objects with information about the servers"
  value       = module.servers.ec2s
}

output "ec2_ids" {
  description = "list of the ids of the servers created, in order as services passed in"
  value       = module.servers.ec2_ids
}

output "lb_public_dns" {
  description = "public dns of the load balancer"
  value       = module.lb.lb_public_dns
}
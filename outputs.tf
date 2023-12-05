output "lighting_ec2" {
  value = module.lighting.ec2
}

output "table_name" {
  value = module.lighting.lighting_table
}

output "heating_ec2" {
  value = module.heating.ec2_heating
}

output "heating_table" {
  value = module.heating.heating_table
}

output "status_ec2" {
  value = module.status.ec2_status
}

output "lb_public_dns" {
  description = "public dns of the load balancer"
  value = module.lb.lb_public_dns
}
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
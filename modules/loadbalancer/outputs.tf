output "lb_public_dns" {
  description = "public dns of the load balancer"
  value       = aws_lb.alb.dns_name
}

output "target_arns" {
  description = "list of arns of the created target groups"
  value       = aws_lb_target_group.service_tg[*].arn
}

### TESTS ###
output "target_groups" {
  description = "a list of all the target group objects"
  value = aws_lb_target_group.service_tg[*]
}
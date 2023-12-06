output "lb_public_dns" {
  description = "public dns of the load balancer"
  value = aws_lb.alb.dns_name
}

output "target_arns"{
  description = "list of arns of the created target groups"
  value = [aws_lb_target_group.status_tg.arn, aws_lb_target_group.status_tg.arn, aws_lb_target_group.heating_tg.arn,]
}
output "lb_public_dns" {
  description = "public dns of the load balancer"
  value = aws_lb.alb.dns_name
}
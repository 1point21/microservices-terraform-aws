### CREATE TARGET GROUPS ###

resource "aws_lb_target_group" "service_tg" {
  count            = length(var.services)
  name             = "${var.project_name}-${var.services[count.index]}-tg"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path     = "/api/${var.services[count.index]}/health"
    protocol = "HTTP"
  }

  tags = {
    Name      = "${var.project_name}-tg-${var.services[count.index]}"
    ManagedBy = "Terraform"
  }
}

### ATTACHMENTS ###

## ATTACH EC2 TO TARGET GROUP - status
resource "aws_lb_target_group_attachment" "alb_tg_attach" {
  count            = length(var.services)
  target_group_arn = aws_lb_target_group.service_tg[count.index].arn
  target_id        = var.ec2_ids[count.index]
}

### ALB CREATION ###
resource "aws_lb" "alb" {
  name               = "${var.project_name}-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_sec_group_sgs
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-app-load-balancer"
  }
}

### LISTENER AND RULES ###

# CREATE LISTENER
resource "aws_lb_listener" "home-server-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg[0].arn
  }
}

# LISTENER RULES
resource "aws_lb_listener_rule" "rule" {
  count        = length(var.services) - 1
  listener_arn = aws_lb_listener.home-server-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg[count.index + 1].arn
  }

  condition {
    path_pattern {
      values = ["/api/${var.services[count.index + 1]}*"]
    }
  }
}


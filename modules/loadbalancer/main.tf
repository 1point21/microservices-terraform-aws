### CREATE TARGET GROUPS ###

# LIGHTS
resource "aws_lb_target_group" "lights_tg" {
  name             = "${var.project_name}-lights-server-tg"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path     = "/api/lights/health"
    protocol = "HTTP"
  }

  tags = {
    Name      = "${var.project_name}-tg-lights"
    ManagedBy = "Terraform"
  }
}

# HEATING
resource "aws_lb_target_group" "heating_tg" {
  name             = "${var.project_name}-heating-server-tg"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path     = "/api/heating/health"
    protocol = "HTTP"
  }
  tags = {
    Name      = "${var.project_name}-tg-heating"
    ManagedBy = "Terraform"
  }
}

# STATUS
resource "aws_lb_target_group" "status_tg" {
  name             = "${var.project_name}-status-server-tg"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path     = "/api/status/health"
    protocol = "HTTP"
  }
  tags = {
    Name      = "${var.project_name}-tg-status"
    ManagedBy = "Terraform"
  }
}

### ATTACHMENTS ###

## ATTACH EC2 TO TARGET GROUP - status
resource "aws_lb_target_group_attachment" "alb_tg_attach-status" {
  target_group_arn = aws_lb_target_group.status_tg.arn
  target_id        = var.status_ec2_id
}

## ATTACH EC2 TO TARGET GROUP - lights
resource "aws_lb_target_group_attachment" "alb_tg_attach-lights" {
  target_group_arn = aws_lb_target_group.lights_tg.arn
  target_id        = var.lights_ec2_id
}

## ATTACH EC2 TO TARGET GROUP - heating
resource "aws_lb_target_group_attachment" "alb_tg_attach-heating" {
  target_group_arn = aws_lb_target_group.heating_tg.arn
  target_id        = var.heating_ec2_id
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
    target_group_arn = aws_lb_target_group.status_tg.arn
  }
}

# LISTENER RULE - HEATING
resource "aws_lb_listener_rule" "heating_rule" {
  listener_arn = aws_lb_listener.home-server-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.heating_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/heating*"]
    }
  }
}

# LISTENER RULE - LIGHTING
resource "aws_lb_listener_rule" "lights_rule" {
  listener_arn = aws_lb_listener.home-server-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lights_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/lights*"]
    }
  }
}
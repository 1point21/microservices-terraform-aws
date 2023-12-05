### CREATE AMI IMAGES ###

# STATUS AMI
resource "aws_ami_from_instance" "status_ami" {
  name = "${var.project_name}status_ami"
  source_instance_id = var.status_ec2_id
}

# LIGHTS AMI
resource "aws_ami_from_instance" "lights_ami" {
  name = "${var.project_name}lights_ami"
  source_instance_id = var.lights_ec2_id
}

# HEATING AMI
resource "aws_ami_from_instance" "heating_ami" {
  name = "${var.project_name}heating_ami"
  source_instance_id = var.heating_ec2_id
}

### LAUNCH TEMPLATES ### 
# STATUS LAUNCH TEMPLATE
resource "aws_launch_template" "status_launch_template" {
  image_id = aws_ami_from_instance.app_server_ami.id
  instance_type = "t2.micro"
  key_name = var.key_name
  user_data = filebase64("${path.module}/user-data.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups = var.security_group_ids
  }

  placement {
    availability_zone = "eu-west-2a"
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "auto-scaling-ec2"
    }
  }
}

### AUTOSCALE GROUPS ###
# STATUS
resource "aws_autoscaling_group" "status_asg" {
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_size
  vpc_zone_identifier  = var.autoscale_public_subnets

  launch_template {
    id = aws_launch_template.app_server_launch_template.id
    version = "$Latest"
  }
}

### AUTOSCALE-TARGETGROUP ATTACHMENT
# STATUS
resource "aws_autoscaling_attachment" "status_asg" {
  autoscaling_group_name = aws_autoscaling_group.status_asg.name
  lb_target_group_arn    = var.status_tg_arn
}
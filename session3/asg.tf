resource "aws_launch_configuration" "example" {
    image_id        = var.ami_id
    instance_type   = var.instance_type
    security_groups = [aws_security_group.first_sg.id]
    user_data       = <<-EOF
            #!/bin/bash
            yum install httpd -y
            echo "Hello from ${var.name}" >> /var/www/html/index.html
            systemctl start httpd
            EOF
    root_block_device {
        delete_on_termination = true
    }
    lifecycle {
        prevent_destroy = false
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launch_configuration.example.name
    min_size             = 3
    max_size             = 3
    vpc_zone_identifier  = data.aws_subnet_ids.default.ids
    target_group_arns    = [aws_lb_target_group.alb_tg.arn]
    health_check_type    = "ELB"
    tags = [
        {
            key                 = "Name"
            value               = "asg instance"
            propagate_at_launch = true
        },
        {
            key = "Environment"
            value = "dev"
            propagate_at_launch = true
        }
    ]
}

resource "aws_security_group" "first_sg" {
  name = "first-web-sg"
  ingress {
      from_port   = var.webserver_port
      to_port     = var.webserver_port
      protocol    = "tcp"
      security_groups = [aws_security_group.alb_sg.id]
  }
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}
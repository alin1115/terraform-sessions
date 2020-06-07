resource "aws_lb" "example" {
    name = "alb-example"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.default.ids
    security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "example" {
    load_balancer_arn = aws_lb.example.arn
    port = var.webserver_port
    protocol = "HTTP"

    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}

resource "aws_security_group" "alb_sg" {
  name = "alb-sg"
  ingress {
    from_port   = var.webserver_port
    to_port     = var.webserver_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "alb_tg" {
    name = "alb-tg"
    port = var.webserver_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener_rule" "alb_listener_rule"{
    listener_arn = aws_lb_listener.example.arn
    priority = 100
    condition {
        path_pattern {
            values = ["*"]
        }
    }
    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_tg.arn
    }
}

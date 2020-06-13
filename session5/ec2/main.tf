resource "aws_instance" "example" {
  ami           = "ami-0affd4508a5d2481b"
  instance_type = var.instance_type
  tags = {
      Name = "FirstInstance",
      Environment = "dev"
  }
  root_block_device {
      delete_on_termination = true
  }

  user_data = data.template_file.user_data.rendered
  vpc_security_group_ids = [aws_security_group.first_sg.id]
}

resource "aws_security_group" "first_sg" {
  name = "first-sg"
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

data "template_file" "user_data" {
    template = file("user-data.sh")
    vars = {
        db_address = data.terraform_remote_state.rds.outputs.db_address
        name = var.name
        greeting = var.greet
    }
}
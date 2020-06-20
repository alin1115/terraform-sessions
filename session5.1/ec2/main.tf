resource "aws_instance" "example" {
  ami           = "ami-0affd4508a5d2481b"
  instance_type = var.instance_type
  key_name = aws_key_pair.key.key_name
  tags = {
      Name = "FirstInstance",
      Environment = "dev"
  }
  root_block_device {
      delete_on_termination = true
  }

  vpc_security_group_ids = [aws_security_group.first_sg.id]

  provisioner "file" {
    content      = data.template_file.index.rendered
    destination = "/tmp/index.html"

    connection {
      type     = "ssh"
      user     = "centos"
      host     = self.public_ip
      private_key = file("/Users/aisuluuomokoeva/.ssh/id_rsa")
    }
  }
}

resource "aws_key_pair" "key" {
  key_name = "terraform101"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBfqJKkxuGxEhNjUCML5kE7FbkGcsqwqmpNElBrodEBmNNTupE/riFJ3iMYh3MobGYvdkHjU1CrT1Ju4Jb96jaaBsXm9bKXa4Y76EUy6aeyi8YjE/Ilpl0g292O2c2sK5dps79G2rSMaS7Nj3vwQI3uqjiy8KAJy5DbbtTEfuOJbBiZ6SNM71YvJnHe/vzZVfBJb5Y7vthtYUjqDMvhhvky0h0RWlvDJJgYUbbb8h0cMI3aK0HM4PIi+Z8xmzipDp+7AbhHJUFsZhTDuNQ36RBpBdLRZe3Sh8x+2krybcx8OmXV4od5dKIhg57jvt73Nc1z9SG/lTx6PC2YOeVal/t aisuluuomokoeva@Aisuluus-MacBook-Air.local"
}

resource "aws_security_group" "first_sg" {
  name = "first-sg"
  ingress {
    from_port   = var.webserver_port
    to_port     = var.webserver_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
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

data "template_file" "index" {
    template = file("index.sh")
    vars = {
        greeting = var.greet
    }
}


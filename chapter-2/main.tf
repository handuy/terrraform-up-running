provider "aws" {
  profile = "admin-general"
  region = "ap-southeast-1"
}

variable "nginx_port" {
  default = 3000
  type = number
}

variable "ssh_port" {
  default = 22
  type = number
}

resource "aws_instance" "test" {
  ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              amazon-linux-extras install docker -y
              service docker start
              docker run -d -p ${var.nginx_port}:80 nginx:alpine
              EOF

  tags = {
    "Name" = "Terraform"
  }

  vpc_security_group_ids = [ aws_security_group.sg_test.id ]
}

resource "aws_security_group" "sg_test" {
  name = "sg_test"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = var.nginx_port
    protocol = "tcp"
    to_port = var.nginx_port
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = var.ssh_port
    protocol = "tcp"
    to_port = var.ssh_port
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
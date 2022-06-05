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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.default.id ]
  }
}

# resource "aws_instance" "test" {
#   ami = "ami-0bd6906508e74f692"
#   instance_type = "t2.micro"

#   user_data = <<-EOF
#               #!/bin/bash
#               amazon-linux-extras install docker -y
#               service docker start
#               docker run -d -p ${var.nginx_port}:80 nginx:alpine
#               EOF

#   tags = {
#     "Name" = "Terraform"
#   }

#   vpc_security_group_ids = [ aws_security_group.sg_test.id ]
# }

resource "aws_launch_template" "nginx" {
  name = "nginx"
  image_id = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"

  vpc_security_group_ids = [ aws_security_group.sg_test.id ]

  user_data = "${base64encode(<<-EOF
              #!/bin/bash
              amazon-linux-extras install docker -y
              service docker start
              docker run -d -p ${var.nginx_port}:80 nginx:alpine
              EOF
  )}"
}

resource "aws_autoscaling_group" "nginx" {
  vpc_zone_identifier = data.aws_subnets.default.ids
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.nginx.id
    version = "$Latest"
  }
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
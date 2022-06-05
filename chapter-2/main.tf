provider "aws" {
  profile = "admin-general"
  region = "ap-southeast-1"
}

resource "aws_instance" "test" {
  ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              amazon-linux-extras install docker -y
              service docker start
              docker run -d -p 3000:80 nginx:alpine
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
    from_port = 3000
    protocol = "tcp"
    to_port = 3000
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
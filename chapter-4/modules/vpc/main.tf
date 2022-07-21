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

resource "aws_security_group" "sg_alb" {
  name = "sg_alb"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = var.http_port
    protocol = "tcp"
    to_port = var.http_port
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
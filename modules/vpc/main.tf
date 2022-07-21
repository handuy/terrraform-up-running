resource "aws_security_group" "sg_ssh" {
  name = "sg_ssh"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = var.ssh_port
    protocol = "tcp"
    to_port = var.ssh_port
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = var.nginx_port
    protocol = "tcp"
    to_port = var.nginx_port
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
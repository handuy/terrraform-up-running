data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.default.id ]
  }
}

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

  target_group_arns = [ aws_lb_target_group.nginx.arn ]
}
1. Create single EC2 instance:

```terraform
resource "aws_instance" "test" {
  ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"

  tags = {
    "Name" = "Terraform"
  }
}
```

2. Create instance with user data

```terraform
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
```

3. Create varialbe

```hcl
variable "nginx_port" {
  default = 3000
  type = number
}
```

4. Use variable in code

```hcl
ingress {
  cidr_blocks = ["0.0.0.0/0"]
  from_port = var.nginx_port
  protocol = "tcp"
  to_port = var.nginx_port
}
```

```hcl
  user_data = <<-EOF
              #!/bin/bash
              amazon-linux-extras install docker -y
              service docker start
              docker run -d -p ${var.nginx_port}:80 nginx:alpine
              EOF
```

5. Create ASG

get subnet ids using Terraform data source
```hcl
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.default.id ]
  }
}
```

create launch templete

```hcl
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
```

create asg
```hcl
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
```

6. Use S3 bucket as backend for storing TF state file

```hcl
terraform {
  backend "s3" {
    bucket = "tf-state-515462467908"
    key    = "global/s3/terraform.tfstate"
    region = "ap-southeast-1"
    profile = "admin-general"

    dynamodb_table = "tf-state-lock"
  }
}
```
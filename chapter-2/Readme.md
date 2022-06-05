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
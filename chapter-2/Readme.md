Create single EC2 instance:

```terraform
resource "aws_instance" "test" {
  ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"

  tags = {
    "Name" = "Terraform"
  }
}
```
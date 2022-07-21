data "template_file" "userdata" {
  template = file("${var.script}")
  vars = {
    private_ip = var.private_ip
  }
}

resource "aws_instance" "myapp" {
  ami = var.instance_ami
  instance_type = var.instance_type

  user_data = data.template_file.userdata.rendered

  tags = {
    "Name" = var.instance_name
  }

  vpc_security_group_ids = [ var.sg_ssh_id ]
  iam_instance_profile = var.instance_profile
}
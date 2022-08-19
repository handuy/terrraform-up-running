data "template_file" "userdata" {
  template = file("${var.script}")
  vars = {
    private_ip = var.private_ip
  }
}

resource "aws_key_pair" "ansible" {
  key_name   = "ansible-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCAShk+yhgOM6wA65PX1Oi2Pzj1BrK/nm0KL5aKW3+uN5PyDRZu+cNF+Fk0SgBC18pNYyLK8GAMJFM9S3Q6jnOy8nMAfMnwUwETFiQy6HHBN34D29M0m2V9BogJLCMYgnO1EMrzpdVX8mfJcPUEPEjEzYw7+Yh8cv0y9fFE5KqqXMC5kADlDA1P8cRM95yr9k0ufXNWs/WrAVhCUGg39xDAZCnUUAXq5HKt307RNlsejI8sfHglgJhKQ/sArmhnsSWpElsCNmg/9sRYMs1VkflM/awCCm3+yd1dPAUs1TISAUTNMRI4V1YDj9rRLoMuoCxg31hSeEwhG1EtlCQb25tr ansible-key-pair"
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

  key_name = aws_key_pair.ansible.key_name
}
provider "aws" {
  profile = "admin-general"
  region = "ap-southeast-1"
}

# terraform {
#   backend "s3" {
#     bucket = "tf-state-515462467908"
#     key    = "global/s3/terraform.tfstate"
#     region = "ap-southeast-1"
#     profile = "admin-general"
#     encrypt = true

#     dynamodb_table = "tf-state-lock"
#   }
# }

module "vpc" {
  source = "../modules/vpc"
  ssh_port = 22
  nginx_port = 9090
}

module "ansible-master" {
  source = "../modules/ec2"

  instance_ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"
  instance_name = "ansible-master"
  script = "script/master.sh"
  sg_ssh_id = module.vpc.sg_ssh_id
  private_ip = module.ansible-slave.instance_private_ip

  depends_on = [ module.ansible-slave ]
}

module "ansible-slave" {
  source = "../modules/ec2"

  instance_ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"
  instance_name = "ansible-slave"
  script = "script/slave.sh"
  sg_ssh_id = module.vpc.sg_ssh_id
}

output "slave_ip" {
  value = module.ansible-slave.instance_private_ip
}
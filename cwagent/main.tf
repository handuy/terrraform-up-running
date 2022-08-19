provider "aws" {
  profile = "duy"
  region = "ap-southeast-1"
}

module "vpc" {
  source = "../modules/vpc"
  ssh_port = 22
  nginx_port = 9090
}

module "webserver" {
  source = "../modules/ec2"

  instance_ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"
  instance_name = "webserver"
  script = "script/master.sh"
  sg_ssh_id = module.vpc.sg_ssh_id
}
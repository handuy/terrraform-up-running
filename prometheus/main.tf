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

module "prometheus" {
  source = "../modules/ec2"

  instance_ami = "ami-02ee763250491e04a"
  instance_type = "t2.micro"
  instance_name = "prometheus"
  script = "./prometheus.sh"
  sg_ssh_id = module.vpc.sg_ssh_id
  instance_profile = ""
}
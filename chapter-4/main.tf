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
  source = "./modules/vpc"

  http_port = 80
  nginx_port = 3000
  ssh_port = 22
}

module "ec2" {
  source = "./modules/ec2"

  instance_ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"
  http_port = 80
  nginx_port = 3000
  ssh_port = 22
  sg_id = module.vpc.sg_test_id
}
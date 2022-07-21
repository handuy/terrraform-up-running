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
  nginx_port = 80
}

module "iam" {
  source = "../modules/iam"
}

module "s3" {
  source = "../modules/s3"
  s3_versioning = "Disabled"
}

module "kops" {
  source = "../modules/ec2"

  instance_ami = "ami-0750a20e9959e44ff"
  instance_type = "t2.micro"
  instance_name = "kops"
  script = "./kops.sh"
  sg_ssh_id = module.vpc.sg_ssh_id
  instance_profile = module.iam.instance_profile_id
}
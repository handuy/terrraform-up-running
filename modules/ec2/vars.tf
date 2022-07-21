variable "instance_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "sg_ssh_id" {
  type = string
}

variable "script" {
  type = string
}

variable "private_ip" {
  type = string
  default = ""
}

variable "instance_profile" {
  type = string
  default = ""
}
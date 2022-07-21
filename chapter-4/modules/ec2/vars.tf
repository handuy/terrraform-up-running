variable "instance_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "http_port" {
  type = number
}

variable "nginx_port" {
  type = number
}

variable "ssh_port" {
  type = number
}

variable "sg_id" {
  type = string
}
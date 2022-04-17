variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"

}

variable "cidr_block_subnet" {
  type    = string
  default = "10.0.1.0/24"
}


variable "instance_type" {
  default = "t2.nano"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "intance_name" {
  type    = string
  default = "web_server"
}

variable "Access_key" {
  type    = string
  default = "AKIA27HSQY2ZD7TUH4U7"
}

variable "secret_key" {
  type    = string
  default = "QQYClvI9WWMFxAlI7Co1LYNSp03wiYffxPeCFROM"
}

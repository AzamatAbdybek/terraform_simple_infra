variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
    type = string
    default = "10.0.10.0/24"
}

variable "avail_zone" {
    type = string
    default = "eu-west-1b"
}

variable "env_prefix" {
    type = string
    default = "dev"
}

variable "my_ip" {
    type = string
    default = "0.0.0.0/0"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "image_name" {
    type = string
    default = "ami-0fe0b2cf0e1f25c8a"
}

variable "instance_count" {
    default = 2
}

variable "instance_name" {
    type = string
    default = "test_server"
}
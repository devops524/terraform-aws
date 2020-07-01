variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.50.0.0/16"
}


variable "az" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

variable "application_name" {
  default = "terraform-test-project"
}

variable "private_cidr_block" {
  default = ["10.50.0.0/19", "10.50.32.0/19", "10.50.64.0/19"]
}

variable "public_cidr_block" {
  default = ["10.50.128.0/22", "10.50.132.0/22"]
}

variable "mysql_pass" {
  default = "password123"
}

variable "certificate_arn" {

}



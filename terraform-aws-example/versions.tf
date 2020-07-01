terraform {
  required_version = "~>0.12.19"
}

provider "aws" {
  version = "~>2.0"
  region  = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "terraform-testing-project"
    region  = "us-east-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}
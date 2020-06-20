terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region        = "us-east-1"
  profile       = "terraform"
  version       = "~> 2.0"
}

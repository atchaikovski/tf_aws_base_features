provider "aws" {
   region = var.region
}

provider "terraform" {}

terraform {
  backend "s3" {
    bucket = "alex-bucket-for-terraform-tests-us"
    key    = "aws-services-learning-us"
    region = "us-east-1"
  }
}
provider "aws" {
   region = var.region
}

provider "terraform" {}

terraform {
  backend "s3" {
    bucket = "alex-bucket-for-terraform-tests"
    key    = "aws-services-learning"
    region = "eu-central-1"
  }
}
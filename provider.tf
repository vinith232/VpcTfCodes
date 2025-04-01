terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
 # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "ajs-24-02-2025"
    key    = "ajs/terraform.tfstate"
    region = "eu-west-2"   
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}



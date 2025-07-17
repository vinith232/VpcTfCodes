terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
 # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "sample03-07-2025"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"   
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}



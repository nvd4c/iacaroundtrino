terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["C:/Users/User/.aws/credentials"]
  profile                  = "default"
}
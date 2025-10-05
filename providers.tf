terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
  }
}

# Default provider (ap-south-1)
provider "aws" {
  region = var.aws_region
  alias  = "ap-south-1"
}

# Provider for us-east-1 (ACM for CloudFront must live here)
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

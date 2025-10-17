variable "region" {
  description = "Primary AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  type    = string
  default = "portfolio"
}

variable "domain_name" {
  type = string
  # your base domain managed in Route53
  description = "root domain (example: mygruham.com)"
}

variable "subdomain" {
  type    = string
  default = "portfolio"
}

variable "full_domain" {
  type        = string
  description = "fully qualified domain for the site (portfolio.mygruham.com)"
}

variable "enable_initial_upload" {
  type        = bool
  default     = false
  description = "If true, Terraform will upload a few core site objects using aws_s3_bucket_object (not recommended for many files)"
}
variable "acm_certificate_region" {
  description = "Region for ACM certificate (CloudFront requires us-east-1)"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "prod"
}
variable "github_org" {
  type        = string
  description = "GitHub organization or username for OIDC"
  default     = "Theramya10"
}
variable "github_repo" {
  description = "GitHub repository for OIDC trust"
  type        = string
}
# Root domain managed in Route53
domain_name = "mygruham.com"

# Full subdomain used for static website hosting (S3 bucket, CloudFront)
full_domain = "portfolio.mygruham.com"

# AWS region for most resources (S3, Route53, IAM)
region = "ap-south-1"

# ACM certificates must be created in us-east-1 for CloudFront
acm_certificate_region = "us-east-1"

# Environment tag (optional, helps with naming)
environment = "prod"

# GitHub repository details (for OIDC role trust)
github_org  = "theramya10"
github_repo = "terraform-infra"


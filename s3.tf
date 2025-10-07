#########################################
# S3 Bucket for Portfolio Website
#########################################

resource "aws_s3_bucket" "site" {
  bucket = var.full_domain # e.g. portfolio.mygruham.com

  tags = {
    Name        = var.full_domain
    Environment = "prod"
  }
}

#########################################
# S3 Bucket Versioning
#########################################

resource "aws_s3_bucket_versioning" "site_versioning" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

#########################################
# S3 Public Access Block (Best Practice)
#########################################

resource "aws_s3_bucket_public_access_block" "site_block" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create CloudFront Origin Access Identity (OAI)
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.full_domain}"
}

# Create CloudFront distribution using S3 origin
resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  aliases = [var.full_domain]

  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = "s3-${aws_s3_bucket.site.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${aws_s3_bucket.site.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  default_root_object = "index.html"

  tags = {
    Name = var.full_domain
  }

  depends_on = [aws_acm_certificate_validation.cert]

}

# S3 bucket policy to allow CloudFront OAI to read objects
data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.site.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "site_policy" {
  provider = aws.ap-south-1
  bucket   = aws_s3_bucket.site.id
  policy   = data.aws_iam_policy_document.s3_policy.json
}

# Route53 alias record to CloudFront
resource "aws_route53_record" "site_alias" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.full_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_cloudfront_distribution.cdn]
}

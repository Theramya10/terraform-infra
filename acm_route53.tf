# Use Route53 zone (created below) for validation records
resource "aws_acm_certificate" "cert" {
  provider          = aws.us-east-1
  domain_name       = var.full_domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Create Route53 validation record
resource "aws_route53_record" "cert_validation" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  ttl     = 600
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
}

# Wait for validation
resource "aws_acm_certificate_validation" "cert_validation_complete" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

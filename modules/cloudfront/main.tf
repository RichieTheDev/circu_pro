resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront"
}


resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = var.s3_origin_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
    origin_id = "S3Origin"
  }

  enabled = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Create a CloudFront Origin Access Identity (OAI) to securely access S3
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront"
}

# Create a CloudFront Key Group
resource "aws_cloudfront_key_group" "key_group" {
  name  = "my-key-group"
  items = [aws_cloudfront_public_key.public_key.id]
}

# Upload Public Key to CloudFront
resource "aws_cloudfront_public_key" "public_key" {
  name        = "my-public-key"
  encoded_key = file("public_key.pem") # Upload your public key
  comment     = "Public key for signing CloudFront URLs"
}

# Define CloudFront distribution with signed URL settings
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
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    trusted_key_groups = [aws_cloudfront_key_group.key_group.id] # Restrict access using key group

    compress    = true
    default_ttl = 3600
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

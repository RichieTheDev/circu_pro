# Create a CloudFront Origin Access Control (OAC) to securely access S3
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "S3-OAC"
  description                       = "OAC for CloudFront to access S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


# Define CloudFront distribution with signed URL settings
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name              = var.s3_bucket_regional_domain
    origin_id                = "S3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled = true

  default_cache_behavior {
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]


    compress    = true
    default_ttl = 3600
    #trusted_key_groups = [aws_cloudfront_key_group.cf_key_group.id]
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

# Upload the Public Key to CloudFront
# resource "aws_cloudfront_public_key" "cf_public_key" {
#   name        = "cloudfront-signed-url-key"
#    encoded_key = file("public_key.pem")
#   comment     = "Public key for signed URLs"
# }

# Create and Associate a CloudFront Key Group
# resource "aws_cloudfront_key_group" "cf_key_group" {
#   name    = "signed-url-key-group"
#   comment = "Key group for signed URLs"
#   items   = [aws_cloudfront_public_key.cf_public_key.id]
# }

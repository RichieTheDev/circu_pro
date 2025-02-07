# Create a CloudFront Origin Access Identity (OAI) to securely access S3
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront"
}

# Define a CloudFront distribution for serving content from S3
resource "aws_cloudfront_distribution" "cdn" {
  # Configure the origin (S3 bucket)
  origin {
    domain_name = var.s3_origin_domain_name
    s3_origin_config {
      # Attach the OAI to allow CloudFront to access the S3 bucket
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
    origin_id = "ConsolidatedS3Origin"
  }

  enabled = true # Enable the CloudFront distribution

  # Define the default caching behavior
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"] # Allow only read methods
    cached_methods         = ["GET", "HEAD"] # Cache only read methods
    target_origin_id       = "ConsolidatedS3Origin"
    viewer_protocol_policy = "redirect-to-https" # Redirect all HTTP requests to HTTPS
    compress               = true                # Enable automatic compression for better performance
    min_ttl                = 300                 # Minimum time-to-live for cached objects (5 minutes)
    default_ttl            = 3600                # Default caching time-to-live (1 hour)
    max_ttl                = 86400               # Maximum time-to-live (24 hours)
  }

  # Set up restrictions (currently allowing global access)
  restrictions {
    geo_restriction {
      restriction_type = "none" # No geo-restrictions
    }
  }

  # Configure SSL/TLS for secure access using the default CloudFront certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

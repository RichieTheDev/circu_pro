# Create source S3 bucket
resource "aws_s3_bucket" "source" {
  bucket = var.source_bucket
}

# Create consolidated S3 bucket
resource "aws_s3_bucket" "consolidated" {
  bucket = var.consolidated_bucket
}

# Apply bucket policy to enforce secure transport
resource "aws_s3_bucket_policy" "secure_bucket" {
  bucket = aws_s3_bucket.source.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Deny",
      Principal = "*",
      Action    = "s3:*",
      Resource  = "${aws_s3_bucket.source.arn}/*",
      Condition = {
        Bool = { "aws:SecureTransport" = "false" }
      }
    }]
  })
}

# Configure lifecycle policy for automatic expiration
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.source.id

  rule {
    id     = "ExpireOldFiles"
    status = "Enabled"
    expiration {
      days = 365
    }
  }
}

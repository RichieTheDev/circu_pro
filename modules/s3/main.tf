# source S3 bucket
resource "aws_s3_bucket" "source" {
  bucket = var.source_bucket
}

# consolidated S3 bucket
resource "aws_s3_bucket" "consolidated" {
  bucket = var.consolidated_bucket

}


# bucket policy to enforce secure transport for both buckets
resource "aws_s3_bucket_policy" "secure_bucket_source" {
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

resource "aws_s3_bucket_policy" "secure_bucket_consolidated" {
  bucket = aws_s3_bucket.consolidated.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Deny",
      Principal = "*",
      Action    = "s3:*",
      Resource  = "${aws_s3_bucket.consolidated.arn}/*",
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

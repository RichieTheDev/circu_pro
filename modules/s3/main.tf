# Create an S3 bucket for storing source files
resource "aws_s3_bucket" "source" {
  bucket = var.source_bucket # Name of the source S3 bucket
}

# Create an S3 bucket for storing consolidated (zipped) files
resource "aws_s3_bucket" "consolidated" {
  bucket = var.consolidated_bucket # Name of the consolidated S3 bucket
}

# Enable versioning on the source bucket to track changes and retain file history
resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled" # Enable versioning for better file tracking and recovery
  }
}

# Enable versioning on the consolidated bucket to retain different versions of zip archives
resource "aws_s3_bucket_versioning" "consolidated" {
  bucket = aws_s3_bucket.consolidated.id
  versioning_configuration {
    status = "Enabled" # Enable versioning to prevent accidental data loss
  }
}

# Restrict public access to the source bucket for security
resource "aws_s3_bucket_public_access_block" "source" {
  bucket                  = aws_s3_bucket.source.id
  block_public_acls       = true # Prevent public ACLs
  block_public_policy     = true # Prevent public bucket policies
  ignore_public_acls      = true # Ignore any public ACLs that might be set
  restrict_public_buckets = true # Restrict public bucket access completely
}

# Restrict public access to the consolidated bucket for security
resource "aws_s3_bucket_public_access_block" "consolidated" {
  bucket                  = aws_s3_bucket.consolidated.id
  block_public_acls       = true # Prevent public ACLs
  block_public_policy     = true # Prevent public bucket policies
  ignore_public_acls      = true # Ignore any public ACLs that might be set
  restrict_public_buckets = true # Restrict public bucket access completely
}

# Enable server-side encryption (SSE) on the source bucket for data security
resource "aws_s3_bucket_server_side_encryption_configuration" "source" {
  bucket = aws_s3_bucket.source.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Use AES-256 encryption for securing stored objects
    }
  }
}

# Enable server-side encryption (SSE) on the consolidated bucket for data security
resource "aws_s3_bucket_server_side_encryption_configuration" "consolidated" {
  bucket = aws_s3_bucket.consolidated.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Use AES-256 encryption to protect stored data
    }
  }
}

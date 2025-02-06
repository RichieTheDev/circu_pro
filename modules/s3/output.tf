output "source_bucket_name" {
  description = "Name of the source S3 bucket"
  value       = aws_s3_bucket.source.bucket
}

output "consolidated_bucket_name" {
  description = "Name of the consolidated S3 bucket"
  value       = aws_s3_bucket.consolidated.bucket
}

output "source_bucket_arn" {
  description = "ARN of the source S3 bucket"
  value       = aws_s3_bucket.source.arn
}

output "consolidated_bucket_arn" {
  description = "ARN of the consolidated S3 bucket"
  value       = aws_s3_bucket.consolidated.arn
}

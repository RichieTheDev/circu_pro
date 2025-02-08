output "source_bucket_name" {
  value = aws_s3_bucket.source_bucket.id
}

output "source_bucket_arn" {
  value = aws_s3_bucket.source_bucket.arn
}

output "consolidated_bucket_name" {
  value = aws_s3_bucket.consolidated_bucket.id
}

output "consolidated_bucket_arn" {
  value = aws_s3_bucket.consolidated_bucket.arn
}

output "s3_bucket_regional_domain" {
  value = aws_s3_bucket.consolidated_bucket.bucket_regional_domain_name
}

# Outputs
output "cloudfront_url" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.cloudfront_url
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.lambda_function_arn
}

output "source_bucket_name" {
  description = "Name of the source S3 bucket"
  value       = module.s3.source_bucket_name
}

output "consolidated_bucket_name" {
  description = "Name of the consolidated S3 bucket"
  value       = module.s3.consolidated_bucket_name
}

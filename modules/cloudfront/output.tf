output "cloudfront_url" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.cdn.domain_name
}
output "cloudfront_arn" {
  value = aws_cloudfront_distribution.cdn.arn
}

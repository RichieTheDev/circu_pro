variable "s3_bucket_name" {
  description = "The name of the S3 bucket used as the CloudFront origin"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "s3_bucket_regional_domain" {
  description = "The regional domain name of the S3 bucket"
  type        = string
}

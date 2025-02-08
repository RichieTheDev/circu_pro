variable "region" {
  description = "AWS region"
  type        = string
}
variable "s3_origin_domain_name" {
  description = "The domain name of the S3 origin for CloudFront"
  type        = string
}

variable "source_bucket" {
  description = "Name of the source S3 bucket"
  type        = string
}

variable "consolidated_bucket" {
  description = "Name of the consolidated S3 bucket"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "source_bucket_arn" {
  description = "ARN of the source S3 bucket"
  type        = string
}

variable "consolidated_bucket_arn" {
  description = "ARN of the consolidated S3 bucket"
  type        = string
}

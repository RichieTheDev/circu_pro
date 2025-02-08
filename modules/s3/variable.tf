variable "source_bucket" {
  description = "Name of the source S3 bucket"
  type        = string
}

variable "consolidated_bucket" {
  description = "Name of the consolidated S3 bucket"
  type        = string
}
variable "cloudfront_arn" {
  description = "The ARN of the CloudFront distribution"
  type        = string

}
variable "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  type        = string
}
variable "s3_vpc_endpoint_id" {
  description = "ID of the S3 VPC endpoint"
  type        = string
}

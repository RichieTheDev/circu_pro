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

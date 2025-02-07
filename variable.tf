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

variable "customer_gateway_ip" {
  description = "Public IP address of the on-premises customer gateway"
  type        = string
}

variable "customer_gateway_asn" {
  description = "ASN for the customer gateway"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the VPN connection is to be attached"
  type        = string
}

variable "allowed_prefixes" {
  description = "CIDR block(s) for the IP range to route over the VPN"
  type        = list(string)
}

variable "dx_gateway_id" {
  description = "Direct Connect Gateway ID"
  type        = string
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID to attach VPN connection"
  type        = string
}

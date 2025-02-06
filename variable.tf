variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
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

variable "vpn_gateway_id" {
  description = "VPN Gateway ID"
  type        = string
}

variable "customer_gateway_id" {
  description = "Customer Gateway ID"
  type        = string
}
# variables.tf

# Customer Gateway Information
variable "customer_gateway_ip" {
  description = "Public IP address of the on-premises customer gateway"
  type        = string
}

variable "customer_gateway_asn" {
  description = "ASN for the customer gateway"
  type        = string
  default     = "64514"
}

# VPC ID where the VPN connection is to be attached
variable "vpc_id" {
  description = "VPC ID where the VPN connection is to be attached"
  type        = string
}

# CIDR block(s) for the IP range to route over the VPN
variable "allowed_prefixes" {
  description = "CIDR block(s) for the IP range to route over the VPN"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

# Direct Connect Gateway ID (optional, only if using Direct Connect)
variable "dx_gateway_id" {
  description = "Direct Connect Gateway ID"
  type        = string
  default     = "" # Leave empty if not using Direct Connect
}

# Transit Gateway ID to attach VPN connection
variable "transit_gateway_id" {
  description = "Transit Gateway ID to attach VPN connection"
  type        = string
}

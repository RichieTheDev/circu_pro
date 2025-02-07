variable "dx_gateway_name" {
  description = "Name of the Direct Connect Gateway"
  type        = string
  default     = "terraform_ipsec_vpn_gateway"
}

variable "dx_gateway_asn" {
  description = "Amazon side ASN for Direct Connect Gateway"
  type        = string
  default     = "64512"
}

variable "transit_gateway_asn" {
  description = "Amazon side ASN for Transit Gateway"
  type        = string
  default     = "64513"
}

variable "transit_gateway_description" {
  description = "Description for Transit Gateway"
  type        = string
  default     = "VPN and Direct Connect Transit Gateway"
}

variable "transit_gateway_cidr" {
  description = "CIDR block for Transit Gateway"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "customer_gateway_bgp_asn" {
  description = "BGP ASN for Customer Gateway"
  type        = number
  default     = 64514
}

variable "customer_gateway_ip" {
  description = "IP Address of the Customer Gateway"
  type        = string
  default     = "10.0.0.1"
}

variable "vpn_allowed_prefixes" {
  description = "Allowed prefixes for VPN connection"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

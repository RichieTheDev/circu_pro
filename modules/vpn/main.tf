# Create a Direct Connect Gateway
resource "aws_dx_gateway" "vpn_gateway" {
  name            = var.dx_gateway_name
  amazon_side_asn = var.dx_gateway_asn
}

# Create a Transit Gateway for network routing
resource "aws_ec2_transit_gateway" "vpn_transit_gateway" {
  amazon_side_asn             = var.transit_gateway_asn
  description                 = var.transit_gateway_description
  transit_gateway_cidr_blocks = var.transit_gateway_cidr
}

# Create a Customer Gateway (on-premises VPN endpoint)
resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
}

# Associate Direct Connect Gateway with Transit Gateway
resource "aws_dx_gateway_association" "vpn_gateway_association" {
  dx_gateway_id         = aws_dx_gateway.vpn_gateway.id
  associated_gateway_id = aws_ec2_transit_gateway.vpn_transit_gateway.id
  allowed_prefixes      = var.vpn_allowed_prefixes
}

# Establish VPN connection (Using Transit Gateway)
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  transit_gateway_id  = aws_ec2_transit_gateway.vpn_transit_gateway.id
  type                = "ipsec.1"
}

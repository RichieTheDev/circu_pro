# Create a Direct Connect Gateway
resource "aws_dx_gateway" "vpn_gateway" {
  name            = "terraform_ipsec_vpn_gateway"
  amazon_side_asn = "64512"
}

# Create a Transit Gateway for network routing
resource "aws_ec2_transit_gateway" "vpn_transit_gateway" {
  amazon_side_asn             = "64513"
  description                 = "VPN and Direct Connect Transit Gateway"
  transit_gateway_cidr_blocks = ["10.0.0.0/24"]
}

# Create a Customer Gateway (on-premises VPN endpoint)
resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 64514
  ip_address = "10.0.0.1"
  type       = "ipsec.1"
}

# Associate Direct Connect Gateway with Transit Gateway
resource "aws_dx_gateway_association" "vpn_gateway_association" {
  dx_gateway_id         = aws_dx_gateway.vpn_gateway.id
  associated_gateway_id = aws_ec2_transit_gateway.vpn_transit_gateway.id

  allowed_prefixes = ["10.0.0.0/8"]
}

# Establish VPN connection
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  transit_gateway_id  = aws_ec2_transit_gateway.vpn_transit_gateway.id
  type                = "ipsec.1"
}

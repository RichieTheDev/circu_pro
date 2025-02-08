
# VPC Setup
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MainVPC"
  }
}

# VPN Gateway
resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MainVPNGateway"
  }
}
# Create an S3 VPC Endpoint for private access
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_vpc.main.default_route_table_id] # Ensure your route table allows S3 access

  tags = {
    Name = "S3VPCGatewayEndpoint"
  }
}

# Customer Gateway (On-Premises VPN Device)
resource "aws_customer_gateway" "on_prem" {
  bgp_asn    = 65000
  ip_address = "172.83.124.10"
  type       = "ipsec.1"
  tags = {
    Name = "OnPremCustomerGateway"
  }
}

# VPN Connection
resource "aws_vpn_connection" "vpn_conn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id = aws_customer_gateway.on_prem.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "MainVPNConnection"
  }
}

# Transit Gateway (if needed for multiple VPCs)
resource "aws_ec2_transit_gateway" "tgw" {
  description                 = "Main Transit Gateway"
  amazon_side_asn             = 64512
  transit_gateway_cidr_blocks = ["10.0.1.0/24"]
  tags = {
    Name = "MainTransitGateway"
  }
}

# Attach VPN Gateway to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.main.id
  subnet_ids         = ["subnet-xxxxxxxx"] # Replace with actual subnet IDs
  tags = {
    Name = "TransitGatewayAttachment"
  }
}

# Direct Connect Gateway (Optional)
resource "aws_dx_gateway" "dx_gw" {
  name            = "DirectConnectGateway"
  amazon_side_asn = 64512
}

resource "aws_dx_gateway_association" "dx_assoc" {
  dx_gateway_id         = aws_dx_gateway.dx_gw.id
  associated_gateway_id = aws_ec2_transit_gateway.tgw.id
  allowed_prefixes = [
    "10.0.0.0/8"
  ]
}


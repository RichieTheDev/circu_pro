# Create a Direct Connect Gateway (DX Gateway)
resource "aws_dx_gateway" "vpn_gateway" {
  name            = "terraform_ipsec_vpn_gateway"
  amazon_side_asn = "64512" # ASN for the AWS side of the VPN connection
}

# Create a Transit Gateway to handle routing between your VPC and Direct Connect Gateway
resource "aws_ec2_transit_gateway" "vpn_transit_gateway" {
  amazon_side_asn             = "64513" # ASN for the AWS side of the Transit Gateway
  description                 = "VPN and Direct Connect Transit Gateway"
  transit_gateway_cidr_blocks = ["10.0.0.0/24"] # CIDR block for your VPN routes
}

# Create Customer Gateway (CGW) on your side (for example, your on-premises VPN gateway)
resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 64514      # ASN for the customer side of the VPN connection
  ip_address = "10.0.0.1" # Your on-premises VPN gateway IP address
  type       = "ipsec.1"

  tags = {
    Name = "customer_vpn_gateway"
  }
}

# Link Direct Connect Gateway with Transit Gateway
resource "aws_dx_gateway_association" "vpn_gateway_association" {
  dx_gateway_id         = aws_dx_gateway.vpn_gateway.id
  associated_gateway_id = aws_ec2_transit_gateway.vpn_transit_gateway.id

  allowed_prefixes = [
    "10.0.0.0/8", # Routes that can be advertised through this association
  ]
}

# Ensure the association between the Direct Connect Gateway and Transit Gateway is established
data "aws_ec2_transit_gateway_dx_gateway_attachment" "vpn_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.vpn_transit_gateway.id
  dx_gateway_id      = aws_dx_gateway.vpn_gateway.id

  depends_on = [
    aws_dx_gateway_association.vpn_gateway_association
  ]
}

# Create the VPN Connection between your Customer Gateway and the Transit Gateway
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id                     = aws_customer_gateway.customer_gateway.id
  outside_ip_address_type                 = "PrivateIpv4" # Ensure private IP address type for secure communication
  transit_gateway_id                      = aws_ec2_transit_gateway.vpn_transit_gateway.id
  transport_transit_gateway_attachment_id = data.aws_ec2_transit_gateway_dx_gateway_attachment.vpn_attachment.id
  type                                    = "ipsec.1" # Define the VPN connection type as IPSec

  tags = {
    Name = "ipsec_vpn_connection"
  }
}

# Optional: Create a VPN Gateway on your side (customer VPN)
resource "aws_vpn_gateway" "customer_vpn_gateway" {
  vpc_id = "vpc-xxxxxxxxxx" # Specify your VPC ID where the VPN Gateway will be attached

  tags = {
    Name = "customer_vpn_gateway"
  }
}

# Optional: Attach the Customer VPN Gateway to your VPC
resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpn_gateway_id = aws_vpn_gateway.customer_vpn_gateway.id
  vpc_id         = "vpc-xxxxxxxxxx"
}

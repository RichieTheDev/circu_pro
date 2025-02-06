# Create an AWS Direct Connect Gateway
# This enables a dedicated network connection between on-premises infrastructure and AWS.
resource "aws_dx_gateway" "dx_gateway" {
  name            = "onprem_to_aws_dx_gateway"  # Name of the Direct Connect Gateway
  amazon_side_asn = "64512"  # ASN (Autonomous System Number) assigned by AWS for BGP routing
}

# Establish a VPN Connection to AWS
# This VPN connection allows secure communication between on-premises infrastructure and AWS.
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.customer_gateway.id  # Reference to the on-premises VPN gateway
  type                = "ipsec.1"  # Specifies that this is an IPSec VPN connection
}

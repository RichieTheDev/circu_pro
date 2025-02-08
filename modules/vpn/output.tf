output "vpn_connection_id" {
  value = aws_vpn_connection.vpn_conn.id
}
output "s3_vpc_endpoint_id" {
  value       = aws_vpc_endpoint.s3_endpoint.id
  description = "The ID of the S3 VPC Endpoint"
}

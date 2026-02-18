output "vpc_cidr" {
  value = aws_vpc.vpc_fiap.cidr_block
}

output "vpc_id" {
  value = aws_vpc.vpc_fiap.id
}

output "subnet_cidr" {
  value = aws_subnet.subnet_public[*].cidr_block
}

output "subnet_id" {
  value = aws_subnet.subnet_public[*].id
}

output "node_group_status" {
  value = aws_eks_node_group.node_group.status
}
output "node_group_arn" {
  value = aws_eks_node_group.node_group.arn
}

output "api_gateway_endpoint" {
  description = "The API Gateway endpoint for the HTTP API (useful after creation)."
  value       = length(aws_apigatewayv2_api.http_api) > 0 ? aws_apigatewayv2_api.http_api[0].api_endpoint : ""
}

output "api_gateway_id" {
  description = "The API Gateway API id."
  value       = length(aws_apigatewayv2_api.http_api) > 0 ? aws_apigatewayv2_api.http_api[0].id : ""
}

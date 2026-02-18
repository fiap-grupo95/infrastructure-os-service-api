// API Gateway HTTP API proxy to the backend (EKS service).
// Note: The backend URL must be provided via the variable `api_backend_url`.
// Typical workflow:
// 1) Apply the existing infra so the k8s Service (type LoadBalancer) is created by Kubernetes.
// 2) Obtain the external LoadBalancer DNS (e.g. a12b3c4d5e6f.us-east-1.elb.amazonaws.com).
// 3) Re-run terraform with -var "api_backend_url=https://<your-lb-dns>" to create the API Gateway.

locals {
  backend_provided = length(trimspace(var.api_backend_url)) > 0
}

resource "aws_apigatewayv2_api" "http_api" {
  count         = local.backend_provided ? 1 : 0
  name          = "mecanica-xpto-http-api"
  protocol_type = "HTTP"
}

# Integration that proxies requests to the backend URL.
resource "aws_apigatewayv2_integration" "proxy" {
  count                  = local.backend_provided ? 1 : 0
  api_id                 = aws_apigatewayv2_api.http_api[0].id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = var.api_backend_url
  payload_format_version = "1.0"

  request_parameters = {
    "overwrite:path" = "$request.path"
  }
}

# Route for all v1 calls -> proxy
resource "aws_apigatewayv2_route" "root_proxy" {
  count              = local.backend_provided ? 1 : 0
  api_id             = aws_apigatewayv2_api.http_api[0].id
  route_key          = "ANY /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.proxy[0].id}"
  authorization_type = "NONE"
}

# Deixar /v1/login explícito e público (sem authorizer)
resource "aws_apigatewayv2_route" "login_public" {
  count              = local.backend_provided ? 1 : 0
  api_id             = aws_apigatewayv2_api.http_api[0].id
  route_key          = "POST /v1/login"
  target             = "integrations/${aws_apigatewayv2_integration.proxy[0].id}"
  authorization_type = "NONE"
}


# Default stage (auto deploy)
resource "aws_apigatewayv2_stage" "default" {
  count       = local.backend_provided ? 1 : 0
  api_id      = aws_apigatewayv2_api.http_api[0].id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigw_logs[0].arn
    format = jsonencode({
      requestId          = "$context.requestId",
      routeKey           = "$context.routeKey",
      status             = "$context.status",
      requestPath        = "$context.path",
      integrationStatus  = "$context.integrationStatus",
      integrationLatency = "$context.integrationLatency"
    })
  }
}

resource "aws_cloudwatch_log_group" "apigw_logs" {
  count             = local.backend_provided ? 1 : 0
  name              = "/aws/apigateway/mecanica-xpto"
  retention_in_days = 7
}


# Optional: allow cross-origin requests by configuring a simple CORS response.
# For full CORS control you may want to add a Lambda or modify integration responses.

output "api_endpoint" {
  value = local.backend_provided ? aws_apigatewayv2_api.http_api[0].api_endpoint : ""
}

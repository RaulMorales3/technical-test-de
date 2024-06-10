
locals {
  name = "${var.project}-${var.environment}-${var.role}"
}
resource "aws_api_gateway_rest_api" "api" {
  name   = local.name
  policy = var.resource_policy
}
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = var.http_method
  authorization = var.authorization
}
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = var.root_path_part
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = var.integration_lambda_root_method
  type                    = "AWS_PROXY"
  uri                     = var.invoke_arn
}


locals {
  name = "${var.project}-${var.environment}-${var.role}"
}
resource "aws_api_gateway_rest_api" "api" {
  name   = local.name
  policy = var.resource_policy
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.root_path_part
}

resource "aws_api_gateway_resource" "root_path_parameter" {
  count       = var.create_path_parameter ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = var.root_path_parameter
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id        = aws_api_gateway_rest_api.api.id
  resource_id        = aws_api_gateway_resource.root.id
  http_method        = var.http_method
  authorization      = var.authorization
  request_parameters = var.request_parameters
}

resource "aws_api_gateway_method" "proxy_root_parameter" {
  count         = var.create_path_parameter ? 1 : 0
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root_path_parameter[0].id
  http_method   = var.http_method
  authorization = var.authorization
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = var.integration_lambda_root_method
  type                    = "AWS_PROXY"
  uri                     = var.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_root_parameter" {
  count       = var.create_path_parameter ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root_path_parameter[0].id
  http_method = aws_api_gateway_method.proxy_root_parameter[0].http_method

  integration_http_method = var.integration_lambda_root_method
  type                    = "AWS_PROXY"
  uri                     = var.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy_root.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy_root.http_method
  status_code = aws_api_gateway_method_response.proxy_response.status_code

  response_templates = {
    "application/json" = ""
  }
}

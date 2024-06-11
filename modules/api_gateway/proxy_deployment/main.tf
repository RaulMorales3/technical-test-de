# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  for_each      = toset(var.function_names)
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.rest_api_arn}/*/*"
}
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = var.rest_api_id
  variables = {
    deployed_at = timestamp()
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_api_gateway_stage" "stage" {
  stage_name    = var.stage_name
  rest_api_id   = var.rest_api_id
  deployment_id = aws_api_gateway_deployment.deployment.id
}

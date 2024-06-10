locals {
  default_env_vars = {PROJECT = var.project, ENVIRONMENT = var.environment}
  env_vars         = merge(local.default_env_vars, var.env_vars)
}

resource "aws_iam_role" "role" {
  name               = "${var.project}-${var.environment}-${var.role}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "policies_attachment" {
  count      = length(var.policies_to_attach)
  policy_arn = var.policies_to_attach[count.index]
  role       = aws_iam_role.role.name
}

resource "aws_iam_policy" "policy_json" {
  count  = var.custom_policy == "" ? 0 : 1
  name   = "${var.project}-${var.environment}-${var.role}-policy"
  policy = var.custom_policy
}

resource "aws_iam_role_policy_attachment" "policy_json_attachment" {
  count      = var.custom_policy == "" ? 0 : 1
  policy_arn = aws_iam_policy.policy_json.*.arn[count.index]
  role       = aws_iam_role.role.name
}

resource "aws_lambda_function" "lambda" {
  function_name                  = "${var.project}-${var.environment}-${var.role}"
  handler                        = var.handler
  role                           = aws_iam_role.role.arn
  runtime                        = var.runtime
  timeout                        = var.timeout
  s3_bucket                      = var.bucket
  s3_key                         = var.key
  s3_object_version              = var.version_id
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers                         = var.layers
  environment {
    variables = local.env_vars
  }

  dynamic "vpc_config" {
     for_each = var.subnets_ids != null && var.security_group_ids != null ? [true] : []
     content {
       security_group_ids = var.security_group_ids
       subnet_ids         = var.subnets_ids
     }
  }

  tags = {
    Name        = "${var.project}-${var.environment}-${var.role}"
    Project     = var.project
    Environment = var.environment
    Role        = var.role
  }
}

resource "aws_lambda_function_event_invoke_config" "lambda_function_event_invoke_config" {
  function_name                = aws_lambda_function.lambda.function_name
  maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
  maximum_retry_attempts       = var.maximum_retry_attempts
}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "archive_file" "lambda_package" {
  type = "zip"
  source_file = "index.js"
  output_path = "index.zip"
}

data "aws_iam_policy_document" "lambda_policy" {
    statement {
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = [
        "arn:aws:logs:${var.region}:${local.account_id}:log-groups:/aws/lambda/${var.project}-${var.environment}-${var.role}*"
      ]
    }
    statement {
      effect = "Allow"
      actions = [
        "dynamodb:ConditionCheckItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
      ]
      resources = [
        "arn:aws:dynamodb:${var.region}:${local.account_id}:table/${var.project}-${var.environment}-${var.role}"
      ]
    }
}
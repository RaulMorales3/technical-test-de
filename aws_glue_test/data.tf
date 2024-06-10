data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_s3_object" "lambda_source_file" {
  bucket   = "test-de-mybucket"
  key      = "${var.project}/lambda/lambda.zip"
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
        "glue:StartJobRun"
      ]
      resources = [
        "arn:aws:glue:${var.region}:${local.account_id}:job/${var.project}-${var.environment}-${var.glue_job_name}*"
      ]
    }
}

data "aws_iam_policy_document" "glue_job_policy" {
    statement {
      effect = "Allow"
      actions = [
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:ConditionCheckItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ]
      resources = [
        "arn:aws:dynamodb:${var.region}:${local.account_id}:table/${var.project}-${var.environment}-${var.role}"
      ]
    }
    statement {
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = [
        "arn:aws:logs:${var.region}:${local.account_id}:log-groups:/aws-glue/jobs/${var.project}-${var.environment}-${var.glue_job_name}*"
      ]
    }
}
module "bucket_project" {
    source      = "../modules/s3_bucket"
    project     = var.project
    environment = var.environment
    role        = var.role
}

module "lambda_project" {
    source        = "../modules/aws_lambda"
    project       = var.project
    environment   = var.environment
    role          = var.role
    bucket        = data.aws_s3_object.lambda_source_file.bucket
    key           = data.aws_s3_object.lambda_source_file.key
    version_id    = data.aws_s3_object.lambda_source_file.version_id
    custom_policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_project.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.bucket_project.bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification_data" {
  bucket = module.bucket_project.id
  dynamic "lambda_function" {
    for_each = length(local.trigger_lambda) == 0 ? [] : local.trigger_lambda
    content {
      lambda_function_arn = module.process_file_lambda.arn
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = try(lambda_function.value.filter_prefix, null)
      filter_suffix       = try(lambda_function.value.filter_suffix, null)
    }
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}

module "glue_job_project" {
  source          = "../modules/aws_glue_job"
  project         = var.project
  environment     = var.environment
  name            = "gluejob"
  script_location = local.glue_job_script_location
}

module "dynamo_table_project" {
    source      = "../modules/dynamo_table"
    project     = var.project
    environment = var.environment
    name        = var.role
    hash_key    = "FileId"
    range_key   = "Timestamp"
    attributes  = [
        {
            name = "FileId"
            type = "S"
        },
        {
            name = "Timestamp"
            type = "S"
        }
    ]
}
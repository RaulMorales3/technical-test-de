module "dynamo_table_employees" {
  source      = "../modules/dynamo_table"
  project     = var.project
  environment = var.environment
  name        = var.role
  hash_key    = "Id"
  range_key   = "BirthDate"
  attributes = [
    {
      name = "Id"
      type = "N"
    },
    {
      name = "BirthDate"
      type = "S"
    }
  ]
}

module "lambda_project" {
  source           = "../modules/aws_lambda"
  project          = var.project
  environment      = var.environment
  role             = var.role
  custom_policy    = data.aws_iam_policy_document.lambda_policy.json
  filename         = "lambda.zip"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  handler          = "get_employees.lambda_handler"
  env_vars = {
    DYNAMO_TABLE = module.dynamo_table_employees.table_name
  }
}

module "proxy_project" {
  source                = "../modules/api_gateway/proxy_root"
  project               = var.project
  environment           = var.environment
  invoke_arn            = module.lambda_project.invoke_arn
  root_path_part        = "employees"
  http_method           = "GET"
  create_path_parameter = true
  root_path_parameter   = "{employee_id}"
  request_parameters    = { "method.request.path.employee_id" = true }
}

module "proxy_deployment_project" {
  source         = "../modules/api_gateway/proxy_deployment"
  rest_api_arn   = module.proxy_project.rest_api_execution_arn
  rest_api_id    = module.proxy_project.rest_api_id
  rest_api_name  = module.proxy_project.rest_api_name
  function_names = [module.lambda_project.function_name]
}

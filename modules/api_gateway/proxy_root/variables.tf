variable "project" {}
variable "environment" {}
variable "invoke_arn" {}
variable "role" {
  default = "api-gateway"
}
variable "resource_policy" {
  default = ""
}
variable "authorization" {
  default     = "NONE"
  description = "authorization used for the method (NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS)"
}
variable "http_method" {
  default     = "ANY"
  description = "(GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
}
variable "integration_lambda_root_method" {
    default = "GET"
}
variable "root_path_part" {
    default = "root"
    description = "Last path segment of root API resource"
}
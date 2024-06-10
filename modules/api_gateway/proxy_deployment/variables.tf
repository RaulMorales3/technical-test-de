variable "rest_api_name" {}
variable "rest_api_arn" {}
variable "rest_api_id" {}
variable "function_names" {
  type = list(string)
}
variable "stage_name" {
  default = "dev"
}
variable "http_method" {
  default = "*"
}
variable "resource_path" {
  default = "*"
}
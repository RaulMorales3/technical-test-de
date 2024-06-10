################################################
# Module generic variables
################################################

variable "project" {}
variable "environment" {}
variable "role" {}

################################################
# lambda source code
################################################

variable "bucket" {
  description = "S3 bucket when the source code is found"
  default     = null
}
variable "key" {
  description = "file key containing the source code"
  default     = null
}
variable "version_id" {
  description = "version id of the file key containing the source code"
  default     = null
}
variable "filename" {
  description = "local file containing source code"
  default     = null
}
variable "source_code_hash" {
  description = "for local deployments hash to re deploy when function changes source code"
  default     = null
}

################################################
# lambda variables
################################################

variable "policies_to_attach" {
  type    = list(any)
  default = []
  description = "list of addiotional policies to attach to the lambda execution role"
}
variable "custom_policy" {
  default = ""
  description = "custom policy for lambda"
}
variable "env_vars" {
  default = {}
  type        = map(any)
  description = "environmental variables for lambda"
}
variable "maximum_event_age_in_seconds" {
  default = 21600
  description = "Maximum age of a request that Lambda sends to a function for processing in seconds"
}

variable "maximum_retry_attempts" {
  default = 0
  description = "Maximum number of times to retry when the function returns an error"
}

variable "runtime" {
  default = "python3.9"
}
variable "handler" {
  default = "lambda_function.lambda_handler"
}
variable "layers" {
  default     = []
  description = "layers for the lambdas"
}
variable "timeout" {
  default = 60
}
variable "security_group_ids" {
  type = list(string)
  default = null
}
variable "subnets_ids" {
  type = list(string)
  default = null
}
variable "memory_size" {
  default = 128
}
variable "reserved_concurrent_executions" {
  default = -1
  description = "0 disables lambda from being triggered and -1 removes any concurrency limitations"
}
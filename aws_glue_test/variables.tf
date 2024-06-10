variable "project" {
  default = "test-de"
}

variable "environment" {
  default = "development"
}

variable "region" {
  default = "us-east-1"
}

variable "role" {
  default = "load-files"
}

variable "glue_job_name" {
  default = "gluejob"
}

locals {
  glue_job_script_location = "s3://${var.project}/glue/glue_script.py"
  trigger_lambda = [
    {
        filter_prefix = "input"
    }
  ]
}
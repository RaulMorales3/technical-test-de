################################################
# Module generic variables
################################################
variable "project" {}
variable "environment" {}
variable "name" {}
variable "region" {
  default = "us-east-1"
  type    = string
}
################################################
# dynamo table variables
################################################
variable "enable_alarms" {
  type        = bool
  default     = "false"
  description = "if enable alarms about reaching maximum scaling capacity will be created"
}

variable "read_capacity" {
  default = null
  type    = number
}
variable "write_capacity" {
  default = null
  type    = number
}
variable "recovery" {
  default = true
}

variable "hash_key" {}
variable "range_key" {
  default = ""
}
variable "attributes" {
  type = list(any)
}
variable "global_secondary_indexes" {
  default = []
  type    = list(any)
}
variable "local_secondary_indexes" {
  default = []
  type    = list(any)
}

variable "stream_enabled" {
  default     = false
  description = "enable dynamo DB streams"
}

variable "stream_type" {
  default     = ""
  description = "one of these values KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES"
}

variable "billing_mode" {
  default     = "PAY_PER_REQUEST"
  description = "one of these values PROVISIONED | PAY_PER_REQUEST"
}

variable "reading_max_capacity" {
  default     = null
  type        = number
  description = "max scalable reading capacity"
}

variable "reading_min_capacity" {
  default     = null
  type        = number
  description = "max scalable reading capacity"
}

variable "reading_target_value" {
  default     = null
  type        = number
  description = "Target reading capacity to autoscale dynamo table"
}
variable "writing_max_capacity" {
  default     = null
  type        = number
  description = "max scalable writing capacity"
}

variable "writing_min_capacity" {
  default     = null
  type        = number
  description = "max scalable writing capacity"
}

variable "writing_target_value" {
  default     = null
  type        = number
  description = "Target writing capacity to autoscale dynamo table"
}

variable "alarm_actions" {
    default     = []
    type        = list(any)
    description = "list of actions to execute when alarms transition into an ALARM state"
}

variable "ok_actions" {
    default     = []
    type        = list(any)
    description = "list of actions to execute when alarms transition into an OK state"
}
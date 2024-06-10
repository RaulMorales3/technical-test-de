variable "project" {}
variable "environment" {}
variable "role" {}
variable "extra_bucket_name" {
  default = ""
}
variable "versioning" {
  default = true
}
variable "mfa_delete" {
  default = false
}
variable "policy" {
  default = ""
}
variable "cors_rule" {
  type    = list
  default = []
}
variable "s3_bucket_acl" {
  type        = string
  default     = null
  description = "(Optional) The canned ACL to apply. Conflicts with `grant`"
  
}
variable "grant" {
  description = "An ACL policy grant. Conflicts with `s3_bucket_acl`"
  type        = list(map(string))
  default     = []
}
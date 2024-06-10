resource "aws_s3_bucket" "bucket" {
  force_destroy = false
  bucket        = "${var.project}-${var.environment}-${var.role}-${var.extra_bucket_name}"

  tags = {
    Name        = "${var.project}-${var.environment}-${var.role}"
    Project     = var.project
    Environment = var.environment
    Role        = var.role
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = s3_bucket_acl
  dynamic "access_control_policy" {
  for_each = length(var.grant) > 0 ? [true] : []
  
  content {
      dynamic "grant" {
      for_each = var.grant
  
      content {
          permission = grant.value.permission
  
          grantee {
          type          = grant.value.type
          id            = try(grant.value.id, null)
          uri           = try(grant.value.uri, null)
          email_address = try(grant.value.email, null)
          }
      }
      }
  
      owner {
      id           = try(var.owner["id"], data.aws_canonical_user_id.this[0].id)
      display_name = try(var.owner["display_name"], null)
      }
  }
  }
}
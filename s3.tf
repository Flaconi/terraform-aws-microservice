locals {
  s3_identifier = length(var.s3_identifier_override) > 0 ? var.s3_identifier_override : join("-", list("bucket", var.name, var.env))
}

resource "aws_s3_bucket" "this" {
  count         = var.s3_enabled ? 1 : 0
  bucket_prefix = local.s3_identifier
  acl           = "private"

  tags = local.tags

  versioning {
    enabled = var.s3_versioning_enabled
  }
}

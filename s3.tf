locals {
  s3_identifier = length(var.s3_identifier_override) > 0 ? var.s3_identifier_override : join("-", list("bucket", var.name, var.env))
}

data "aws_kms_key" "s3" {
  count  = var.s3_enabled ? 1 : 0
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "this" {
  count         = var.s3_enabled ? 1 : 0
  bucket_prefix = local.s3_identifier
  acl           = "private"

  force_destroy = var.s3_force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }


  tags = local.tags

  versioning {
    enabled = var.s3_versioning_enabled
  }
}

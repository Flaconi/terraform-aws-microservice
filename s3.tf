locals {
  # Local check used to make sure that s3_identifier is set
  s3_identifier_check = {
    signum(length(var.s3_identifier)) = var.s3_identifier
  }
  s3_encryption_check = {
    signum(length(element(concat(aws_kms_key.this.*.arn, [""]), 0))) = element(concat(aws_kms_key.this.*.arn, [""]), 0)
  }
}

# TODO: remove if this is obsolete
data "aws_kms_key" "s3" {
  count  = var.s3_enabled ? 1 : 0
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "this" {
  count  = var.s3_enabled ? 1 : 0
  bucket = local.s3_identifier_check[1]
  acl    = "private"

  force_destroy = var.s3_force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = local.s3_encryption_check[1]
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = local.tags

  versioning {
    enabled = var.s3_versioning_enabled
  }

  dynamic "lifecycle_rule" {
    for_each = var.s3_lifecycle_rules
    iterator = rule

    content {
      id      = rule.value.id
      enabled = lookup(rule.value, "enabled", true)
      prefix  = rule.value.prefix
      expiration {
        days = rule.value.expiration_days
      }
    }
  }

}


data "aws_iam_policy_document" "bucket_policy" {
  count = var.s3_enabled ? 1 : 0

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${join("", aws_s3_bucket.this.*.id)}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "StringNotEquals"
      values   = ["aws:kms"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }

  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.this[0].id}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "Null"
      values   = ["true"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.s3_enabled ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.id)
  policy = join("", data.aws_iam_policy_document.bucket_policy.*.json)
}

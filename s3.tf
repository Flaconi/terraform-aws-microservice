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

  force_destroy = var.s3_force_destroy

  tags = local.tags
}

resource "aws_s3_bucket_acl" "this" {
  count  = var.s3_enabled ? 1 : 0
  bucket = aws_s3_bucket.this[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.s3_enabled ? 1 : 0
  bucket = aws_s3_bucket.this[count.index].bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.s3_encryption_check[1]
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.s3_enabled ? 1 : 0
  bucket = aws_s3_bucket.this[count.index].id
  versioning_configuration {
    status = var.s3_versioning_enabled
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  depends_on = [aws_s3_bucket_versioning.this]

  count  = var.s3_enabled && local.length_s3_lifecycle_rules > 0 ? 1 : 0
  bucket = aws_s3_bucket.this[count.index].id

  dynamic "rule" {
    for_each = var.s3_lifecycle_rules

    content {
      id     = rule.value.id
      status = lookup(rule.value, "status", "Enabled")
      filter {
        prefix = rule.value.prefix
      }
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

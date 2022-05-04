locals {
  # Determine if S3 for DB dumps should be enabled
  rds_dumps_enabled = var.rds_enabled && var.rds_enable_s3_dump

  rds_s3_bucket_policy_principal_identifiers = concat(
    var.rds_s3_dump_role_arn == "" && local.rds_dumps_enabled ? flatten(concat(
      [aws_iam_role.rds_dumps[0].arn],
      var.rds_s3_kms_dump_key_additional_role_arns
      )) : flatten(concat(
      [var.rds_s3_dump_role_arn],
      var.rds_s3_kms_dump_key_additional_role_arns
    ))
  )
}

data "aws_iam_policy_document" "rds_dumps" {
  count = local.rds_dumps_enabled ? 1 : 0

  statement {
    sid = "AllowReadWriteAccessWithRDSIAMRole"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.rds_dumps[0].arn,
      "${aws_s3_bucket.rds_dumps[0].arn}/*",
    ]

    principals {
      identifiers = local.rds_s3_bucket_policy_principal_identifiers
      type        = "AWS"
    }
  }

  # Allow to read by specific IPs only if those IPs were defined
  dynamic "statement" {
    for_each = length(var.rds_s3_dump_allowed_ips) > 0 ? ["1"] : []

    content {
      sid = "AllowIP"

      principals {
        identifiers = ["*"]
        type        = "*"
      }

      actions = [
        "s3:GetObject",
        "s3:ListBucket",
      ]

      resources = [
        aws_s3_bucket.rds_dumps[0].arn,
        "${aws_s3_bucket.rds_dumps[0].arn}/*",
      ]

      condition {
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = var.rds_s3_dump_allowed_ips
      }
    }
  }
}

data "aws_iam_policy_document" "rds_dumps_role_trust" {
  count = local.rds_dumps_enabled && var.rds_s3_dump_role_arn == "" ? 1 : 0

  statement {
    sid = "TrustRDS"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "rds_dumps_role" {
  count = local.rds_dumps_enabled && var.rds_s3_dump_role_arn == "" ? 1 : 0

  statement {
    sid = "AllowDumpS3BucketInteraction"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.rds_dumps[0].arn,
      "${aws_s3_bucket.rds_dumps[0].arn}/*",
    ]
  }

  statement {
    sid = "AllowDumpS3BucketObjectEncryption"

    actions = [
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt",
    ]

    resources = [aws_kms_key.this[0].arn]
  }
}

resource "aws_s3_bucket_policy" "rds_dumps" {
  count = local.rds_dumps_enabled ? 1 : 0

  bucket = aws_s3_bucket.rds_dumps[0].id
  policy = data.aws_iam_policy_document.rds_dumps[0].json
}

resource "aws_s3_bucket" "rds_dumps" {
  count = local.rds_dumps_enabled ? 1 : 0

  bucket = "flaconi-${var.rds_s3_dump_name_prefix}-${local.rds_identifier}-rds-dumps"
  acl    = "private"

  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.this[0].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = local.tags

  versioning {
    enabled = true
  }
}

resource "aws_iam_role_policy" "rds_dumps_role" {
  count = local.rds_dumps_enabled && var.rds_s3_dump_role_arn == "" ? 1 : 0

  name = "${local.rds_identifier}-rds-dumps-integration"
  role = aws_iam_role.rds_dumps[0].id

  policy = data.aws_iam_policy_document.rds_dumps_role[0].json
}

resource "aws_iam_role" "rds_dumps" {
  count = local.rds_dumps_enabled && var.rds_s3_dump_role_arn == "" ? 1 : 0

  name = "${local.rds_identifier}-rds-dumps-integration"

  assume_role_policy = data.aws_iam_policy_document.rds_dumps_role_trust[0].json
}

resource "aws_db_instance_role_association" "this" {
  count = local.rds_dumps_enabled ? 1 : 0

  db_instance_identifier = module.rds.db_instance_id
  feature_name           = "S3_INTEGRATION"
  role_arn               = var.rds_s3_dump_role_arn == "" ? aws_iam_role.rds_dumps[0].arn : var.rds_s3_dump_role_arn
}

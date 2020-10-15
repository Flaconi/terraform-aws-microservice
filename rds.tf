locals {
  rds_identifier = length(var.rds_identifier_override) > 0 ? var.rds_identifier_override : var.name
  rds_db_name    = length(regexall("sqlserver-.*", var.rds_engine)) > 0 ? null : (length(var.rds_dbname_override) > 0 ? var.rds_dbname_override : local.rds_identifier)
  password       = var.rds_use_random_password ? join("", random_string.password.*.result) : var.rds_admin_pass
}

# -------------------------------------------------------------------------------------------------
# AWS Security Group
# -------------------------------------------------------------------------------------------------
locals {
  rds_sg_rule_name = {
    mysql        = "mysql-tcp"
    postgres     = "postgresql-tcp"
    sqlserver-se = "mssql-tcp"
    oracle-se2   = "oracle-db-tcp"
    default      = "postgresql-tcp"
  }
}

module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.14.0"

  create = var.rds_enabled

  name        = "${local.rds_identifier}-sg"
  description = "Security group for - ${local.rds_identifier}"
  vpc_id      = element(concat(data.aws_vpc.this.*.id, [""]), 0)

  ingress_cidr_blocks = var.rds_allowed_subnet_cidrs
  ingress_rules       = [lookup(local.rds_sg_rule_name, var.rds_engine, "postgresql-tcp")]

  tags = var.tags
}

# Random password generator
resource "random_string" "password" {
  count   = var.rds_enabled ? 1 : 0
  length  = 16
  special = false
}

# -------------------------------------------------------------------------------------------------
# AWS RDS Database
# -------------------------------------------------------------------------------------------------
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.18.0"

  create_db_instance        = var.rds_enabled
  create_db_option_group    = var.rds_enabled
  create_db_parameter_group = var.rds_enabled
  create_db_subnet_group    = var.rds_enabled

  option_group_name    = var.rds_option_group_name != "default" ? var.rds_option_group_name : "${var.rds_option_group_name}:${var.rds_family}"
  parameter_group_name = var.rds_parameter_group_name
  db_subnet_group_name = var.rds_db_subnet_group_name
  ca_cert_identifier   = var.rds_ca_cert_identifier

  identifier = lower(local.rds_identifier)

  publicly_accessible = false

  engine                = var.rds_engine
  engine_version        = var.rds_engine_version
  major_engine_version  = var.rds_major_engine_version
  instance_class        = var.rds_node_type
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  family                = var.rds_family
  license_model         = var.rds_license_model

  name     = local.rds_db_name
  username = var.rds_admin_user
  password = local.password
  port     = var.rds_port

  iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled

  vpc_security_group_ids = local.rds_security_group_ids

  storage_encrypted = var.rds_storage_encrypted
  kms_key_id        = var.rds_kms_key_id

  maintenance_window = var.rds_maintenance_window
  backup_window      = var.rds_backup_window

  tags                       = local.tags
  copy_tags_to_snapshot      = var.rds_copy_tags_to_snapshot
  subnet_ids                 = flatten(data.aws_subnet_ids.rds.*.ids)
  final_snapshot_identifier  = "${var.env}-${local.rds_identifier}-snapshot"
  backup_retention_period    = var.rds_backup_retention_period
  auto_minor_version_upgrade = var.rds_auto_minor_version_upgrade

  enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports

  performance_insights_retention_period = null

  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot

  multi_az = var.rds_multi_az

  parameters = var.rds_parameters
  options    = var.rds_options
}


# -------------------------------------------------------------------------------------------------
# AWS RDS S3 bucket for DB dumps
# -------------------------------------------------------------------------------------------------
locals {
  # Determine if S3 for DB dumps should be enabled
  rds_dumps_enabled = var.rds_enabled && var.rds_enable_s3_dump
}

# S3 bucket which will be used to store DB dumps
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

# Buckup S3 bucket policy
data "aws_iam_policy_document" "rds_dumps" {
  count = local.rds_dumps_enabled ? 1 : 0

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.rds_dumps[0].arn}/*"]

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
    resources = ["${aws_s3_bucket.rds_dumps[0].arn}/*"]

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

# Marry S3 bucket with policy
resource "aws_s3_bucket_policy" "rds_dumps" {
  count = local.rds_dumps_enabled ? 1 : 0

  bucket = aws_s3_bucket.rds_dumps[0].id
  policy = data.aws_iam_policy_document.rds_dumps[0].json
}

# Policy for RDS role
data "aws_iam_policy_document" "rds_dumps_role" {
  count = local.rds_dumps_enabled ? 1 : 0

  statement {
    sid = "AllowDumpS3BucketInteraction"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]

    resources = [
      aws_s3_bucket.rds_dumps[0].arn,
      "${aws_s3_bucket.rds_dumps[0].arn}/*",
    ]
  }
}

# Trust policy for RDS role
data "aws_iam_policy_document" "rds_dumps_role_trust" {
  count = local.rds_dumps_enabled ? 1 : 0

  statement {
    sid = "TrustRDS"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

# Marry RDS role with policies
resource "aws_iam_role_policy" "rds_dumps_role" {
  count = local.rds_dumps_enabled ? 1 : 0

  name = "${local.rds_identifier}-rds-dumps-integration"
  role = aws_iam_role.rds_dumps[0].id

  policy = data.aws_iam_policy_document.rds_dumps_role[0].json
}

# Marry RDS with dumps role
resource "aws_iam_role" "rds_dumps" {
  count = local.rds_dumps_enabled ? 1 : 0

  name = "${local.rds_identifier}-rds-dumps-integration"

  assume_role_policy = data.aws_iam_policy_document.rds_dumps_role_trust[0].json
}

resource "aws_db_instance_role_association" "this" {
  count = local.rds_dumps_enabled ? 1 : 0

  db_instance_identifier = module.rds.this_db_instance_id
  feature_name           = "S3_INTEGRATION"
  role_arn               = aws_iam_role.rds_dumps[0].arn
}

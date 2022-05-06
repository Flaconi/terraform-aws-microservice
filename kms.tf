locals {
  ## An OR condition can be created to enable KMS whenever we have a resource which uses it.
  kms_enabled = var.s3_enabled || (var.rds_enabled && var.rds_enable_s3_dump)
}

resource "aws_kms_key" "this" {
  count       = local.kms_enabled ? 1 : 0
  description = "KMS key for encrypting - ${var.env} - ${var.name}"
  policy      = data.aws_iam_policy_document.kms_key[0].json
  tags = local.tags
}

resource "aws_kms_alias" "this" {
  count         = local.kms_enabled ? 1 : 0
  name          = format("alias/%s/microservice/%s", var.env, var.name)
  target_key_id = aws_kms_key.this[0].id
}

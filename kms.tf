resource "aws_kms_key" "this" {
  count       = var.kms_enabled ? 1 : 0
  description = "KMS key for encrypting"

  tags = local.tags
}

resource "aws_kms_alias" "this" {
  count         = var.kms_enabled ? 1 : 0
  name          = format("alias/%s/microservice/%s", var.env, var.name)
  target_key_id = element(concat(aws_kms_key.this.*.id, [""]), 0)
}

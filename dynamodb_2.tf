locals {
  dynamodb2_name = length(var.dynamodb2_name_override) > 0 ? var.dynamodb2_name_override : var.name
}


resource "null_resource" "dynamodb2_checker" {
  provisioner "local-exec" {
    command = "echo 'Condition failed. Expected: DynamoDB enabled, but hash_key not set' && exit 1"
  }

  count = var.dynamodb2_enabled && length(var.dynamodb2_hash_key) < 1 ? 1 : 0
}

module "dynamodb2" {
  source  = "cloudposse/dynamodb/aws"
  version = "0.10.0"

  namespace = ""
  stage     = ""
  name      = local.dynamodb2_name
  hash_key  = var.dynamodb2_hash_key
  range_key = var.dynamodb2_range_key
  enabled   = var.dynamodb2_enabled ? "true" : "false"

  dynamodb_attributes        = var.dynamodb2_attributes
  global_secondary_index_map = var.dynamodb2_global_secondary_index_map
  local_secondary_index_map  = var.dynamodb2_local_secondary_index_map

  # We can always extend the defaults and add them
  enable_autoscaler = false

  tags = local.tags
}

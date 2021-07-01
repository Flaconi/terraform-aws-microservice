locals {
  dynamodb3_name = length(var.dynamodb3_name_override) > 0 ? var.dynamodb3_name_override : join("-", [var.name, "3"])
}


resource "null_resource" "dynamodb3_checker" {
  provisioner "local-exec" {
    command = "echo 'Condition failed. Expected: DynamoDB enabled, but hash_key not set' && exit 1"
  }

  count = var.dynamodb3_enabled && length(var.dynamodb3_hash_key) < 1 ? 1 : 0
}

module "dynamodb3" {
  source  = "cloudposse/dynamodb/aws"
  version = "0.29.0"

  namespace      = ""
  stage          = ""
  name           = local.dynamodb3_name
  hash_key       = var.dynamodb3_hash_key
  hash_key_type  = var.dynamodb3_hash_key_type
  range_key      = var.dynamodb3_range_key
  range_key_type = var.dynamodb3_range_key_type
  enabled        = var.dynamodb3_enabled

  dynamodb_attributes        = var.dynamodb3_attributes
  global_secondary_index_map = var.dynamodb3_global_secondary_index_map
  local_secondary_index_map  = var.dynamodb3_local_secondary_index_map

  # We can always extend the defaults and add them
  autoscale_write_target       = var.dynamodb3_autoscale_write_target
  autoscale_read_target        = var.dynamodb3_autoscale_read_target
  autoscale_min_read_capacity  = var.dynamodb3_autoscale_min_read_capacity
  autoscale_max_read_capacity  = var.dynamodb3_autoscale_max_read_capacity
  autoscale_min_write_capacity = var.dynamodb3_autoscale_min_write_capacity
  autoscale_max_write_capacity = var.dynamodb3_autoscale_max_write_capacity
  enable_autoscaler            = var.dynamodb3_enable_autoscaler

  tags = local.tags
}

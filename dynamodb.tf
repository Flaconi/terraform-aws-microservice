locals {
  dynamodb_name = length(var.dynamodb_name_override) > 0 ? var.dynamodb_name_override : var.name
}

resource "null_resource" "dynamodb_checker" {
  provisioner "local-exec" {
    command = "echo 'Condition failed. Expected: DynamoDB enabled, but hash_key not set' && exit 1"
  }

  count = var.dynamodb_enabled && length(var.dynamodb_hash_key) < 1 ? 1 : 0
}

module "dynamodb" {
  source  = "cloudposse/dynamodb/aws"
  version = "0.29.0"

  namespace      = ""
  stage          = ""
  name           = local.dynamodb_name
  hash_key       = var.dynamodb_hash_key
  hash_key_type  = var.dynamodb_hash_key_type
  range_key      = var.dynamodb_range_key
  range_key_type = var.dynamodb_range_key_type
  enabled        = var.dynamodb_enabled

  dynamodb_attributes        = var.dynamodb_attributes
  global_secondary_index_map = var.dynamodb_global_secondary_index_map
  local_secondary_index_map  = var.dynamodb_local_secondary_index_map

  autoscale_write_target       = var.dynamodb_autoscale_write_target
  autoscale_read_target        = var.dynamodb_autoscale_read_target
  autoscale_min_read_capacity  = var.dynamodb_autoscale_min_read_capacity
  autoscale_max_read_capacity  = var.dynamodb_autoscale_max_read_capacity
  autoscale_min_write_capacity = var.dynamodb_autoscale_min_write_capacity
  autoscale_max_write_capacity = var.dynamodb_autoscale_max_write_capacity
  enable_autoscaler            = var.dynamodb_enable_autoscaler

  tags = local.tags
}

locals {
  dynamodb2_name = length(var.dynamodb2_name_override) > 0 ? var.dynamodb2_name_override : join("-", [var.name, "2"])
}


resource "null_resource" "dynamodb2_checker" {
  provisioner "local-exec" {
    command = "echo 'Condition failed. Expected: DynamoDB enabled, but hash_key not set' && exit 1"
  }

  count = var.dynamodb2_enabled && length(var.dynamodb2_hash_key) < 1 ? 1 : 0
}

module "dynamodb2" {
  source  = "cloudposse/dynamodb/aws"
  version = "0.29.0"

  namespace      = ""
  stage          = ""
  name           = local.dynamodb2_name
  hash_key       = var.dynamodb2_hash_key
  hash_key_type  = var.dynamodb2_hash_key_type
  range_key      = var.dynamodb2_range_key
  range_key_type = var.dynamodb2_range_key_type
  enabled        = var.dynamodb2_enabled

  dynamodb_attributes        = var.dynamodb2_attributes
  global_secondary_index_map = var.dynamodb2_global_secondary_index_map
  local_secondary_index_map  = var.dynamodb2_local_secondary_index_map

  # We can always extend the defaults and add them
  autoscale_write_target       = var.dynamodb2_autoscale_write_target
  autoscale_read_target        = var.dynamodb2_autoscale_read_target
  autoscale_min_read_capacity  = var.dynamodb2_autoscale_min_read_capacity
  autoscale_max_read_capacity  = var.dynamodb2_autoscale_max_read_capacity
  autoscale_min_write_capacity = var.dynamodb2_autoscale_min_write_capacity
  autoscale_max_write_capacity = var.dynamodb2_autoscale_max_write_capacity
  enable_autoscaler            = var.dynamodb2_enable_autoscaler

  tags = local.tags
}

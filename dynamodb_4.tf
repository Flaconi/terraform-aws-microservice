locals {
  dynamodb4_name = length(var.dynamodb4_name_override) > 0 ? var.dynamodb4_name_override : join("-", [var.name, "4"])
}


resource "null_resource" "dynamodb4_checker" {
  provisioner "local-exec" {
    command = "echo 'Condition failed. Expected: DynamoDB enabled, but hash_key not set' && exit 1"
  }

  count = var.dynamodb4_enabled && length(var.dynamodb4_hash_key) < 1 ? 1 : 0
}

module "dynamodb4" {
  source  = "cloudposse/dynamodb/aws"
  version = "0.30.0"

  namespace      = ""
  stage          = ""
  name           = local.dynamodb4_name
  hash_key       = var.dynamodb4_hash_key
  hash_key_type  = var.dynamodb4_hash_key_type
  range_key      = var.dynamodb4_range_key
  range_key_type = var.dynamodb4_range_key_type
  enabled        = var.dynamodb4_enabled
  billing_mode   = var.dynamodb4_billing
  table_class    = var.dynamodb4_table_class

  dynamodb_attributes        = var.dynamodb4_attributes
  global_secondary_index_map = var.dynamodb4_global_secondary_index_map
  local_secondary_index_map  = var.dynamodb4_local_secondary_index_map

  # We can always extend the defaults and add them
  autoscale_write_target       = var.dynamodb4_autoscale_write_target
  autoscale_read_target        = var.dynamodb4_autoscale_read_target
  autoscale_min_read_capacity  = var.dynamodb4_autoscale_min_read_capacity
  autoscale_max_read_capacity  = var.dynamodb4_autoscale_max_read_capacity
  autoscale_min_write_capacity = var.dynamodb4_autoscale_min_write_capacity
  autoscale_max_write_capacity = var.dynamodb4_autoscale_max_write_capacity
  enable_autoscaler            = var.dynamodb4_enable_autoscaler

  tags = local.tags
}

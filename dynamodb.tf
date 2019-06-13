resource "null_resource" "dynamodb_checker" {
  provisioner "local-exec" {
    command = "echo 'Condition failed. Expected: DynamoDB enabled, but hash_key not set' && exit 1"
  }

  count = var.dynamodb_enabled && length(var.dynamodb_hash_key) < 1 ? 1 : 0
}

module "dynamodb" {
  source  = "git::https://github.com/Flaconi/terraform-aws-dynamodb.git?ref=v0.12.0"

  namespace = ""
  stage     = ""
  name      = var.name
  hash_key  = var.dynamodb_hash_key
  range_key = var.dynamodb_range_key
  enabled   = var.dynamodb_enabled ? "true" : "false"

  dynamodb_attributes        = var.dynamodb_attributes
  global_secondary_index_map = var.dynamodb_global_secondary_index_map
  local_secondary_index_map  = var.dynamodb_local_secondary_index_map

  # We can always extend the defaults and add them
  enable_autoscaler = false

  tags = local.tags
}


locals {
  tags = merge(
    var.tags,
    {
      "Name"        = "${var.env}-${var.name}"
      "Environment" = var.env
    },
  )
  rds_security_group_ids = concat(
    [module.rds_sg.security_group_id],
    flatten(data.aws_security_groups.for_rds[*].ids),
  )

  length_s3_lifecycle_rules = length(var.s3_lifecycle_rules)

  dynamodb_iam_enabled = var.dynamodb_enabled || var.dynamodb2_enabled || var.dynamodb3_enabled || var.dynamodb4_enabled
  dynamodb_tables_arns = concat(
    var.dynamodb_enabled && var.iam_role_enabled ? ["arn:aws:dynamodb:*:*:table/${module.dynamodb.table_id}"] : [],
    var.dynamodb2_enabled && var.iam_role_enabled ? ["arn:aws:dynamodb:*:*:table/${module.dynamodb2.table_id}"] : [],
    var.dynamodb3_enabled && var.iam_role_enabled ? ["arn:aws:dynamodb:*:*:table/${module.dynamodb3.table_id}"] : [],
    var.dynamodb4_enabled && var.iam_role_enabled ? ["arn:aws:dynamodb:*:*:table/${module.dynamodb4.table_id}"] : [],
  )
  dynamodb_tables_records = [for t in toset(local.dynamodb_tables_arns) : "${t}/*"]
}

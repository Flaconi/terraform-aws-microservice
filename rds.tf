locals {
  rds_identifier                  = length(var.rds_identifier_override) > 0 ? var.rds_identifier_override : var.name
  rds_db_name                     = length(regexall("sqlserver-.*", var.rds_engine)) > 0 ? null : (length(var.rds_dbname_override) > 0 ? var.rds_dbname_override : local.rds_identifier)
  password                        = var.rds_use_random_password ? join("", random_string.password.*.result) : var.rds_admin_pass
  rds_final_snapshot_identifier   = length(var.rds_final_snapshot_identifier_override) > 0 ? var.rds_final_snapshot_identifier_override : "${var.env}-${local.rds_identifier}-snapshot"
  enhanced_monitoring_interval    = contains([1, 5, 10, 15, 30, 60], var.rds_enhanced_monitoring_interval) ? var.rds_enhanced_monitoring_interval : 0
  create_enhanced_monitoring_role = local.enhanced_monitoring_interval > 0 ? true : false
  enhanced_monitoring_role_name   = local.enhanced_monitoring_interval > 0 ? "${var.env}-${local.rds_identifier}-monitoring" : null
}

# -------------------------------------------------------------------------------------------------
# AWS Security Group
# -------------------------------------------------------------------------------------------------
locals {
  rds_sg_rule_name = {
    mysql        = "mysql-tcp"
    postgres     = "postgresql-tcp"
    sqlserver-se = "mssql-tcp"
    sqlserver-ee = "mssql-tcp"
    oracle-se2   = "oracle-db-tcp"
    default      = "postgresql-tcp"
  }
}

module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.1"

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
  version = "6.5.2"

  apply_immediately = var.rds_apply_immediately

  create_db_instance        = var.rds_enabled
  create_db_option_group    = var.rds_enabled
  create_db_parameter_group = var.rds_enabled
  create_db_subnet_group    = var.rds_enabled

  option_group_name    = var.rds_option_group_name
  parameter_group_name = var.rds_parameter_group_name
  db_subnet_group_name = var.rds_db_subnet_group_name
  ca_cert_identifier   = var.rds_ca_cert_identifier

  db_subnet_group_description  = var.rds_db_subnet_group_description
  parameter_group_description  = var.rds_parameter_group_description
  option_group_description     = var.rds_option_group_description
  option_group_use_name_prefix = var.rds_option_group_use_name_prefix

  identifier = lower(local.rds_identifier)

  publicly_accessible = false

  engine                = var.rds_engine
  engine_version        = var.rds_engine_version
  major_engine_version  = var.rds_major_engine_version
  instance_class        = var.rds_node_type
  storage_type          = var.rds_storage_type
  iops                  = var.rds_iops
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  family                = var.rds_family
  license_model         = var.rds_license_model

  db_name                     = local.rds_db_name
  username                    = var.rds_admin_user
  password                    = local.password
  port                        = var.rds_port
  manage_master_user_password = false

  iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled

  vpc_security_group_ids = local.rds_security_group_ids

  storage_encrypted = var.rds_storage_encrypted
  kms_key_id        = var.rds_kms_key_id

  maintenance_window = var.rds_maintenance_window
  backup_window      = var.rds_backup_window

  tags                             = local.tags
  copy_tags_to_snapshot            = var.rds_copy_tags_to_snapshot
  subnet_ids                       = flatten(data.aws_subnets.rds.*.ids)
  final_snapshot_identifier_prefix = local.rds_final_snapshot_identifier
  snapshot_identifier              = var.rds_db_snapshot_name
  backup_retention_period          = var.rds_backup_retention_period
  auto_minor_version_upgrade       = var.rds_auto_minor_version_upgrade

  enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports

  performance_insights_enabled          = var.rds_performance_insights_enabled
  performance_insights_retention_period = var.rds_performance_insights_retention_period

  monitoring_interval = local.enhanced_monitoring_interval
  monitoring_role_arn = local.enhanced_monitoring_interval > 0 ? aws_iam_role.enhanced_monitoring[0].arn : ""

  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot

  multi_az = var.rds_multi_az

  parameters = var.rds_parameters
  options    = var.rds_options

  timeouts              = var.rds_timeouts
  option_group_timeouts = var.rds_option_group_timeouts
}

# -------------------------------------------------------------------------------------------------
# AWS RDS Enhanced monitoring
# -------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# The "enhanced_monitoring" resources can be removed once this PR gets merged
# https://github.com/terraform-aws-modules/terraform-aws-rds/pull/311 and you
# bump the version of the module
resource "aws_iam_role" "enhanced_monitoring" {
  count = local.create_enhanced_monitoring_role ? 1 : 0

  name               = local.enhanced_monitoring_role_name
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = local.create_enhanced_monitoring_role ? 1 : 0

  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

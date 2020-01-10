locals {
  rds_identifier = length(var.rds_identifier_override) > 0 ? var.rds_identifier_override : var.name
  rds_db_name    = length(var.rds_dbname_override) > 0 ? var.rds_dbname_override : local.rds_identifier
  password       = var.rds_use_random_password ? join("", random_string.password.*.result) : var.rds_admin_pass
}

# -------------------------------------------------------------------------------------------------
# AWS Security Group
# -------------------------------------------------------------------------------------------------
locals {
  rds_sg_rule_name = {
    mysql    = "mysql-tcp"
    postgres = "postgresql-tcp"
    default  = "postgresql-tcp"
  }
}

module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.0.1"

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
  version = "v2.6.0"

  create_db_instance        = var.rds_enabled
  create_db_option_group    = var.rds_enabled
  create_db_parameter_group = var.rds_enabled
  create_db_subnet_group    = var.rds_enabled

  option_group_name    = var.rds_option_group_name
  parameter_group_name = var.rds_parameter_group_name
  db_subnet_group_name = var.rds_db_subnet_group_name
  ca_cert_identifier   = var.rds_ca_cert_identifier

  identifier = local.rds_identifier

  publicly_accessible = false

  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  major_engine_version = var.rds_major_engine_version
  instance_class       = var.rds_node_type
  allocated_storage    = var.rds_allocated_storage
  family               = var.rds_family

  name     = local.rds_db_name
  username = var.rds_admin_user
  password = local.password
  port     = var.rds_port

  iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled

  vpc_security_group_ids = [module.rds_sg.this_security_group_id]

  storage_encrypted = var.rds_storage_encrypted
  kms_key_id        = var.rds_kms_key_id

  maintenance_window = var.rds_maintenance_window
  backup_window      = var.rds_backup_window

  tags                      = local.tags
  subnet_ids                = flatten(data.aws_subnet_ids.rds.*.ids)
  final_snapshot_identifier = "${var.env}-${local.rds_identifier}-snapshot"
  backup_retention_period   = var.rds_backup_retention_period

  performance_insights_retention_period = null

  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot

  multi_az = var.rds_multi_az

  parameters = var.rds_parameters
  options    = var.rds_options
}

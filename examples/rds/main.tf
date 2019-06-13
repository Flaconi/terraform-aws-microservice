module "ms_sample_rds" {
  source = "../../"

  env  = "playground"
  name = "sample"

  vpc_tag_filter = {
    "Name" = "dev-vpc"
    "env"  = "dev"
  }

  # rds_subnet_tag_filter sets the datasource to match the subnet_id's where the RDS will be located
  rds_subnet_tag_filter = {
    "Name" = "dev-rds-subnet*"
    "env"  = "dev"
  }

  # rds_enabled enables RDS 
  rds_enabled = true

  # rds_allowed_subnet_cidrs specifices the allowed subnets
  #rds_allowed_subnet_cidrs = ["127.0.0.1/32"]

  # rds_admin_user sets the admin user, defaults to admin
  # rds_admin_user          = "demouser"
  # rds_identifier_override overrides the name of the RDS instance, instead of `var.name`
  # rds_identifier_override = "overridename"

  # rds_engine sets the RDS instance engine
  # rds_engine = "mysql"

  # rds_major_engine_version RDS instance major engine version
  # rds_major_engine_version = 5.7

  # rds_family Parameter Group"
  # rds_family = "mysql5.7"

  # rds_node_type sets VM type which should be taken for nodes in the RDS instance
  # rds_node_type = "db.t3.micro"

  # rds_multi_az sets multi-az
  # rds_multi_az = true

  # rds_storage_type sets the RDS storage type
  # rds_storage_type = "gp2"

  # rds_allocated_storage sets the RDS storage size in Gb
  # rds_allocated_storage = "20"

  # rds_admin_pass sets the password in case `rds_admin_pass` is set to false
  # rds_admin_pass = ""

  # rds_use_random_password switched on sets a random password for the rds instance
  # rds_use_random_password = true

  # rds_parameter_group_name Parameter group for database
  # rds_parameter_group_name = ""

  # rds_option_group_name option groups for database
  # rds_option_group_name = ""

  # rds_port TCP port where DB accept connections
  # rds_port = "3306"

  # rds_db_subnet_group_name Subnet groups for RDS instance
  # rds_db_subnet_group_name = ""

  # rds_backup_retention_period Retention period for DB snapshots in days
  rds_backup_retention_period = 14

  # rds_deletion_protection Protect RDS instance from deletion
  rds_deletion_protection = false

  # rds_skip_final_snapshot Protect RDS instance from deletion
  rds_skip_final_snapshot = true

  # rds_storage_encrypted - enable encryption for RDS instance storage"
  rds_storage_encrypted = true

  # rds_kms_key_id - KMS key ARN for storage encryption, defaults to "" = RDS/KMS
  rds_kms_key_id = ""

  # rds_maintenance_window - Window of RDS Maintenance
  rds_maintenance_window = "Mon:16:00-Mon:18:00"

  # rds_backup_window - Backup Window
  rds_backup_window = "03:00-06:00"

  tags = {}
}


# -------------------------------------------------------------------------------------------------
# Environment (required)
# -------------------------------------------------------------------------------------------------
variable "env" {
  description = "The environment name to which this project will be applied against (e.g.: common, dev, prod, testing)"
}

variable "name" {
  description = "The name of the microservice, the dependent resources will be created with this name interpolated"
}

variable "tags" {
  description = "tags to propagate to the resources"
  type        = map(any)
}

variable "rds_copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  type        = bool
  default     = true
}

# -------------------------------------------------------------------------------------------------
# VPC and Networking
# -------------------------------------------------------------------------------------------------
variable "vpc_tag_filter" {
  description = "The map of tags to match the VPC tags with where the RDS or Redis or other networked AWS component of the Microservice resides"
  default     = {}
}

variable "additional_sg_names_for_rds" {
  description = "Name(s) of the additional VPC Security Group(s) to be attached to the RDS instance."
  default     = []
  type        = list
}

# -------------------------------------------------------------------------------------------------
# IAM Role
# -------------------------------------------------------------------------------------------------
variable "iam_role_enabled" {
  description = "Set to false to prevent iam role creation"
  default     = false
}

variable "iam_role_principals_arns" {
  description = "List of ARNs to allow assuming the iam role. Could be AWS services or accounts, Kops nodes, IAM users or groups"
  type        = list(string)
  default     = []
}

# -------------------------------------------------------------------------------------------------
# IAM User
# -------------------------------------------------------------------------------------------------
variable "iam_user_enabled" {
  description = "Set to false to prevent iam user creation"
  default     = false
}

variable "iam_user_path" {
  description = "Set the path for the iam user"
  default     = "/"
}

variable "iam_inline_policies" {
  description = "Policies applied to the assuming role"
  default     = []
}

# -------------------------------------------------------------------------------------------------
# Route53
# -------------------------------------------------------------------------------------------------
variable "aws_route53_record_ttl" {
  description = "Time to live for DNS record used by the endpoints"
  default     = "60"
}

variable "aws_route53_zone_endpoints_enabled" {
  description = "To enable the lookup of the domain used for RDS/Redis private endpoint"
  default     = false
}

variable "aws_route53_zone_public_endpoint_enabled" {
  description = "To enable the lookup of the domain used for RDS/Redis public endpoint, we need to set this to true"
  default     = true
}

variable "aws_route53_zone_private_endpoint_enabled" {
  description = "To enable the lookup of the domain used for RDS/Redis private endpoint, we need to set this to true"
  default     = true
}

variable "endpoints_domain" {
  description = "The domain / route53 zone we need to add a record with"
  default     = ""
}

# -------------------------------------------------------------------------------------------------
# DynamoDB
# -------------------------------------------------------------------------------------------------
variable "dynamodb_enabled" {
  description = "Set to false to prevent the module from creating any dynamodb resources"
  default     = false
}

variable "dynamodb_name_override" {
  description = "define dynamodb_name_override to set a name differnt from var.name "
  default     = ""
}

variable "dynamodb_hash_key" {
  description = "DynamoDB table Hash Key"
  type        = string
  default     = ""
}

variable "dynamodb_hash_key_type" {
  type        = string
  default     = "S"
  description = "Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}


variable "dynamodb_range_key" {
  description = "DynamoDB table Range Key"
  type        = string
  default     = ""
}

variable "dynamodb_range_key_type" {
  type        = string
  default     = "S"
  description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "dynamodb_attributes" {
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
  default     = []
}

variable "dynamodb_global_secondary_index_map" {
  description = "Additional global secondary indexes in the form of a list of mapped values"
  type = list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
  default = []
}

variable "dynamodb_local_secondary_index_map" {
  description = "Additional local secondary indexes in the form of a list of mapped values"
  type = list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
  default = []
}

variable "dynamodb_autoscale_write_target" {
  type        = number
  default     = 50
  description = "The target value for DynamoDB write autoscaling"
}

variable "dynamodb_autoscale_read_target" {
  type        = number
  default     = 50
  description = "The target value for DynamoDB read autoscaling"
}

variable "dynamodb_autoscale_min_read_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB autoscaling min read capacity"
}

variable "dynamodb_autoscale_max_read_capacity" {
  type        = number
  default     = 20
  description = "DynamoDB autoscaling max read capacity"
}

variable "dynamodb_autoscale_min_write_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB autoscaling min write capacity"
}

variable "dynamodb_autoscale_max_write_capacity" {
  type        = number
  default     = 20
  description = "DynamoDB autoscaling max write capacity"
}

variable "dynamodb_enable_autoscaler" {
  type        = bool
  default     = true
  description = "Flag to enable/disable DynamoDB autoscaling"
}

# -------------------------------------------------------------------------------------------------
# DynamoDB 2 Allows for a second table in Dynamodb
# -------------------------------------------------------------------------------------------------

variable "dynamodb2_enabled" {
  description = "Set to false to prevent the module from creating any dynamodb resources"
  default     = false
}

variable "dynamodb2_name_override" {
  description = "define dynamodb2_name_override to set a name differnt from var.name"
  default     = ""
}

variable "dynamodb2_hash_key" {
  description = "DynamoDB table Hash Key"
  type        = string
  default     = ""
}

variable "dynamodb2_hash_key_type" {
  type        = string
  default     = "S"
  description = "Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "dynamodb2_range_key" {
  description = "DynamoDB table Range Key"
  type        = string
  default     = ""
}

variable "dynamodb2_range_key_type" {
  type        = string
  default     = "S"
  description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "dynamodb2_attributes" {
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
  default     = []
}

variable "dynamodb2_global_secondary_index_map" {
  description = "Additional global secondary indexes in the form of a list of mapped values"
  type = list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
  default = []
}

variable "dynamodb2_local_secondary_index_map" {
  description = "Additional local secondary indexes in the form of a list of mapped values"
  type = list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
  default = []
}

variable "dynamodb2_autoscale_write_target" {
  type        = number
  default     = 50
  description = "The target value for DynamoDB write autoscaling"
}

variable "dynamodb2_autoscale_read_target" {
  type        = number
  default     = 50
  description = "The target value for DynamoDB read autoscaling"
}

variable "dynamodb2_autoscale_min_read_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB autoscaling min read capacity"
}

variable "dynamodb2_autoscale_max_read_capacity" {
  type        = number
  default     = 20
  description = "DynamoDB autoscaling max read capacity"
}

variable "dynamodb2_autoscale_min_write_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB autoscaling min write capacity"
}

variable "dynamodb2_autoscale_max_write_capacity" {
  type        = number
  default     = 20
  description = "DynamoDB autoscaling max write capacity"
}

variable "dynamodb2_enable_autoscaler" {
  type        = bool
  default     = true
  description = "Flag to enable/disable DynamoDB autoscaling"
}

# -------------------------------------------------------------------------------------------------
# DynamoDB 3 Allows for a third dynamodb table
# -------------------------------------------------------------------------------------------------

variable "dynamodb3_enabled" {
  description = "Set to false to prevent the module from creating any dynamodb resources"
  default     = false
}

variable "dynamodb3_name_override" {
  description = "define dynamodb3_name_override to set a name differnt from var.name"
  default     = ""
}

variable "dynamodb3_hash_key" {
  description = "DynamoDB table Hash Key"
  type        = string
  default     = ""
}

variable "dynamodb3_hash_key_type" {
  type        = string
  default     = "S"
  description = "Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "dynamodb3_range_key" {
  description = "DynamoDB table Range Key"
  type        = string
  default     = ""
}

variable "dynamodb3_range_key_type" {
  type        = string
  default     = "S"
  description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "dynamodb3_attributes" {
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
  default     = []
}

variable "dynamodb3_global_secondary_index_map" {
  description = "Additional global secondary indexes in the form of a list of mapped values"
  type = list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
  default = []
}

variable "dynamodb3_local_secondary_index_map" {
  description = "Additional local secondary indexes in the form of a list of mapped values"
  type = list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
  default = []
}


variable "dynamodb3_autoscale_write_target" {
  type        = number
  default     = 50
  description = "The target value for DynamoDB write autoscaling"
}

variable "dynamodb3_autoscale_read_target" {
  type        = number
  default     = 50
  description = "The target value for DynamoDB read autoscaling"
}

variable "dynamodb3_autoscale_min_read_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB autoscaling min read capacity"
}

variable "dynamodb3_autoscale_max_read_capacity" {
  type        = number
  default     = 20
  description = "DynamoDB autoscaling max read capacity"
}

variable "dynamodb3_autoscale_min_write_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB autoscaling min write capacity"
}

variable "dynamodb3_autoscale_max_write_capacity" {
  type        = number
  default     = 20
  description = "DynamoDB autoscaling max write capacity"
}

variable "dynamodb3_enable_autoscaler" {
  type        = bool
  default     = true
  description = "Flag to enable/disable DynamoDB autoscaling"
}


# -------------------------------------------------------------------------------------------------
# Redis
# -------------------------------------------------------------------------------------------------
variable "redis_enabled" {
  description = "Set to false to prevent the module from creating any redis resources"
  default     = false
}

variable "redis_cluster_id_override" {
  description = "Redis cluster ID. Use only lowercase, numbers and -, _., only use when it needs to be different from var.name"
  default     = ""
}

variable "redis_port" {
  description = "Redis port"
  default     = "6379"
}

variable "redis_instance_type" {
  description = "Redis instance type"
  default     = "cache.m4.large"
}

variable "redis_shards_count" {
  description = "Number of shards"
  default     = 1
}

variable "redis_group_engine_version" {
  description = "Redis engine version to be used"
  default     = "5.0.0"
}

variable "redis_group_parameter_group_name" {
  description = "Redis parameter group name"
  default     = "default.redis5.0.cluster.on"
}

variable "redis_snapshot_window" {
  description = "Redis snapshot window"
  default     = "00:00-05:00"
}

variable "redis_maintenance_window" {
  description = "Redis snapshot window"
  default     = "mon:10:00-mon:12:00"
}

variable "redis_auto_minor_version_upgrade" {
  description = "Redis allow auto minor version upgrade"
  default     = true
}

variable "redis_at_rest_encryption_enabled" {
  description = "Redis encrypt storage"
  default     = false
}

variable "redis_transit_encryption_enabled" {
  description = "Redis encrypt transit TLS"
  default     = false
}

variable "redis_replicas_count" {
  description = "Number of replica nodes in each node group"
  default     = 1
}

variable "redis_allowed_subnet_cidrs" {
  description = "List of CIDRs/subnets which should be able to connect to the Redis cluster"
  type        = list(string)
  default     = ["127.0.0.1/32"]
}

variable "redis_subnet_tag_filter" {
  description = "The Map to filter the subnets of the VPC where the Redis component of the Microservice resides"
  default     = {}
}

# -------------------------------------------------------------------------------------------------
# RDS
# -------------------------------------------------------------------------------------------------
variable "rds_enabled" {
  description = "Set to false to prevent the module from creating any rds resources"
  type        = bool
  default     = false
}

variable "rds_enable_s3_dump" {
  description = "Set to true to allow the module to create RDS DB dump resources."
  type        = bool
  default     = false
}

variable "rds_s3_dump_name_prefix" {
  description = "The S3 name prefix"
  type        = string
  default     = ""
}

variable "rds_s3_dump_allowed_ips" {
  description = "List of CIDRs allowed to access data on the S3 bucket for RDS DB dumps"
  type        = list(string)
  default     = []
}

variable "rds_identifier_override" {
  description = "RDS identifier override. Use only lowercase, numbers and -, _., only use when it needs to be different from var.name"
  default     = ""
}

variable "rds_dbname_override" {
  description = "RDS DB Name override in case the identifier is not wished as db name"
  default     = ""
}

variable "rds_allowed_subnet_cidrs" {
  description = "List of CIDRs/subnets which should be able to connect to the RDS instance"
  type        = list(string)
  default     = ["127.0.0.1/32"]
}

# -------------------------------------------------------------------------------------------------
# RDS instance engine
# -------------------------------------------------------------------------------------------------
variable "rds_engine" {
  description = "RDS instance engine"
  type        = string
  default     = "mysql"
}

variable "rds_major_engine_version" {
  description = "RDS instance major engine version"
  type        = string
  default     = "5.7"
}

variable "rds_auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = false
}

variable "rds_engine_version" {
  description = "RDS instance engine version"
  type        = string
  default     = "5.7.19"
}

variable "rds_family" {
  description = "Parameter Group"
  type        = string
  default     = "mysql5.7"
}

# -------------------------------------------------------------------------------------------------
# RDS instance node type and replication
# -------------------------------------------------------------------------------------------------
variable "rds_node_type" {
  description = "VM type which should be taken for nodes in the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_multi_az" {
  description = "Replication settings"
  default     = true
}

# -------------------------------------------------------------------------------------------------
# RDS instance storage settings
# -------------------------------------------------------------------------------------------------
variable "rds_storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp2"
}

variable "rds_allocated_storage" {
  description = "Storage size in Gb"
  type        = string
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

# -------------------------------------------------------------------------------------------------
# RDS instance admin user & pass
# -------------------------------------------------------------------------------------------------
variable "rds_admin_user" {
  description = "Admin user name, should default when empty"
  type        = string
  default     = "admin"
}

variable "rds_admin_pass" {
  description = "Admin user password. At least 8 characters."
  type        = string
  default     = ""
}

variable "rds_use_random_password" {
  description = "with rds_use_random_password set to true the RDS database will be configured with a random password"
  default     = true
}

# -------------------------------------------------------------------------------------------------
# RDS IAM settings
# -------------------------------------------------------------------------------------------------

variable "rds_iam_database_authentication_enabled" {
  description = "Enable / disable IAM database authentication"
  default     = "false"
}


# -------------------------------------------------------------------------------------------------
# RDS instance settings
# -------------------------------------------------------------------------------------------------
variable "rds_parameter_group_name" {
  description = "Parameter group for database"
  type        = string
  default     = ""
}

variable "rds_parameters" {
  description = "List of RDS parameters to apply"
  type        = list(map(string))
  default     = []
}

variable "rds_option_group_name" {
  description = "Option groups for database"
  type        = string
  default     = "default"
}

variable "rds_options" {
  description = "A list of RDS Options to apply"
  type        = any
  default     = []
}

variable "rds_ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance."
  type        = string
  default     = "rds-ca-2019"
}

variable "rds_license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  type        = string
  default     = ""
}

variable "rds_enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
  type        = list(string)
  default     = []
}

# -------------------------------------------------------------------------------------------------
# RDS instance networking
# -------------------------------------------------------------------------------------------------
variable "rds_port" {
  description = "TCP port where DB accept connections"
  type        = string
  default     = "3306"
}

variable "rds_db_subnet_group_name" {
  description = "Subnet groups for RDS instance"
  type        = string
  default     = ""
}

variable "rds_subnet_tag_filter" {
  description = "The Map to filter the subnets of the VPC where the RDS component of the Microservice resides"
  default     = {}
}

# -------------------------------------------------------------------------------------------------
# RDS instance backup settings
# -------------------------------------------------------------------------------------------------
variable "rds_backup_retention_period" {
  description = "Retention period for DB snapshots in days"
  type        = string
  default     = 14
}

variable "rds_deletion_protection" {
  description = "Protect RDS instance from deletion"
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  default     = false
}

# -------------------------------------------------------------------------------------------------
# RDS instance encryption settings
# -------------------------------------------------------------------------------------------------
variable "rds_storage_encrypted" {
  description = "Enable encryption for RDS instance storage"
  default     = true
}

variable "rds_kms_key_id" {
  description = "KMS key ARN for storage encryption"
  type        = string
  default     = ""
}

variable "rds_maintenance_window" {
  description = "Window of RDS Maintenance"
  type        = string
  default     = "Mon:16:00-Mon:18:00"
}

variable "rds_backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-06:00"
}

# -------------------------------------------------------------------------------------------------
# S3 Bucket Creation
# -------------------------------------------------------------------------------------------------

variable "s3_enabled" {
  description = "S3 bucket creation and iam policy creation enabled"
  type        = bool
  default     = false
}

variable "s3_identifier" {
  description = "The S3 Bucket name"
  type        = string
  default     = ""
}

variable "s3_force_destroy" {
  description = "S3 Force destroy"
  type        = bool
  default     = true
}

variable "s3_versioning_enabled" {
  description = "S3 Versioning enabled"
  type        = bool
  default     = true
}

variable "s3_lifecycle_rules" {
  description = "S3 Lifecycle rules"
  default     = []
}

# -------------------------------------------------------------------------------------------------
# SQS (1)
# -------------------------------------------------------------------------------------------------
variable "sqs1_enabled" {
  description = "Set to false to prevent the module from creating any sqs resources"
  default     = false
}

variable "sqs1_name_override" {
  description = "define sqs1_name_override to set a name differnt from var.name "
  default     = ""
}

variable "sqs1_delay_seconds" {
  description = "define sqs1_delay_seconds "
  default     = 0
}

variable "sqs1_fifo_queue" {
  description = "Boolean designating a FIFO queue"
  default     = false
}

variable "sqs1_max_message_size" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 262144
}

variable "sqs1_receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  default     = 0
}

variable "sqs1_redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  default     = ""
}

variable "sqs1_visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = 30
}

variable "sqs1_dlq_enabled" {
  description = "Set to false to prevent the module from creating any sqs-dql resources"
  default     = false
}

# -------------------------------------------------------------------------------------------------
# SQS (2)
# -------------------------------------------------------------------------------------------------
variable "sqs2_enabled" {
  description = "Set to false to prevent the module from creating any sqs resources"
  default     = false
}

variable "sqs2_name_override" {
  description = "define sqs2_name_override to set a name differnt from var.name "
  default     = ""
}

variable "sqs2_delay_seconds" {
  description = "define sqs2_delay_seconds "
  default     = 0
}

variable "sqs2_fifo_queue" {
  description = "Boolean designating a FIFO queue"
  default     = false
}

variable "sqs2_max_message_size" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 262144
}

variable "sqs2_receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  default     = 0
}

variable "sqs2_redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  default     = ""
}

variable "sqs2_visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = 30
}

variable "sqs2_dlq_enabled" {
  description = "Set to false to prevent the module from creating any sqs-dql resources"
  default     = false
}

# -------------------------------------------------------------------------------------------------
# SQS (3)
# -------------------------------------------------------------------------------------------------
variable "sqs3_enabled" {
  description = "Set to false to prevent the module from creating any sqs resources"
  default     = false
}

variable "sqs3_name_override" {
  description = "define sqs3_name_override to set a name differnt from var.name "
  default     = ""
}

variable "sqs3_delay_seconds" {
  description = "define sqs3_delay_seconds "
  default     = 0
}

variable "sqs3_fifo_queue" {
  description = "Boolean designating a FIFO queue"
  default     = false
}

variable "sqs3_max_message_size" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 262144
}

variable "sqs3_receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  default     = 0
}

variable "sqs3_redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  default     = ""
}

variable "sqs3_visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = 30
}

variable "sqs3_dlq_enabled" {
  description = "Set to false to prevent the module from creating any sqs-dql resources"
  default     = false
}

# -------------------------------------------------------------------------------------------------
# SQS (4)
# -------------------------------------------------------------------------------------------------
variable "sqs4_enabled" {
  description = "Set to false to prevent the module from creating any sqs resources"
  default     = false
}

variable "sqs4_name_override" {
  description = "define sqs4_name_override to set a name differnt from var.name "
  default     = ""
}

variable "sqs4_delay_seconds" {
  description = "define sqs4_delay_seconds "
  default     = 0
}

variable "sqs4_fifo_queue" {
  description = "Boolean designating a FIFO queue"
  default     = false
}

variable "sqs4_max_message_size" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 262144
}

variable "sqs4_receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  default     = 0
}

variable "sqs4_redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  default     = ""
}

variable "sqs4_visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = 30
}

variable "sqs4_dlq_enabled" {
  description = "Set to false to prevent the module from creating any sqs-dql resources"
  default     = false
}

# -------------------------------------------------------------------------------------------------
# SQS (5)
# -------------------------------------------------------------------------------------------------
variable "sqs5_enabled" {
  description = "Set to false to prevent the module from creating any sqs resources"
  default     = false
}

variable "sqs5_name_override" {
  description = "define sqs5_name_override to set a name differnt from var.name "
  default     = ""
}

variable "sqs5_delay_seconds" {
  description = "define sqs5_delay_seconds "
  default     = 0
}

variable "sqs5_fifo_queue" {
  description = "Boolean designating a FIFO queue"
  default     = false
}

variable "sqs5_max_message_size" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 262144
}

variable "sqs5_receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  default     = 0
}

variable "sqs5_redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  default     = ""
}

variable "sqs5_visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = 30
}

variable "sqs5_dlq_enabled" {
  description = "Set to false to prevent the module from creating any sqs-dql resources"
  default     = false
}

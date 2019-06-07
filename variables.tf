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
  default     = {}
}

# -------------------------------------------------------------------------------------------------
# VPC and Networking
# -------------------------------------------------------------------------------------------------
variable "vpc_tag_filter" {
  description = "The map of tags to match the VPC tags with where the RDS or Redis or other networked AWS component of the Microservice resides"
  default     = {}
}

# -------------------------------------------------------------------------------------------------
# IAM Role
# -------------------------------------------------------------------------------------------------
variable "iam_role_enabled" {
  description = "Set to false to prevent iam role creation"
  default     = "false"
}

variable "iam_role_principals_arns" {
  description = "List of ARNs to allow assuming the iam role. Could be AWS services or accounts, Kops nodes, IAM users or groups"
  type        = "list"
  default     = []
}

# -------------------------------------------------------------------------------------------------
# IAM User
# -------------------------------------------------------------------------------------------------
variable "iam_user_enabled" {
  description = "Set to false to prevent iam user creation"
  default     = "false"
}

variable "iam_user_path" {
  description = "Set the path for the iam user"
  default     = "/"
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
  default     = "false"
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
  default     = "false"
}

variable "dynamodb_hash_key" {
  description = "DynamoDB table Hash Key"
  type        = "string"
  default     = ""
}

variable "dynamodb_range_key" {
  description = "DynamoDB table Range Key"
  type        = "string"
  default     = ""
}

variable "dynamodb_attributes" {
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
  type        = "list"
  default     = []
}

variable "dynamodb_global_secondary_index_map" {
  description = "Additional global secondary indexes in the form of a list of mapped values"
  type        = "list"
  default     = []
}

variable "dynamodb_local_secondary_index_map" {
  description = "Additional local secondary indexes in the form of a list of mapped values"
  type        = "list"
  default     = []
}

# -------------------------------------------------------------------------------------------------
# Redis
# -------------------------------------------------------------------------------------------------
variable "redis_enabled" {
  description = "Set to false to prevent the module from creating any redis resources"
  default     = "false"
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
  default     = "false"
}

variable "redis_transit_encryption_enabled" {
  description = "Redis encrypt transit TLS"
  default     = "false"
}

variable "redis_replicas_count" {
  description = "Number of replica nodes in each node group"
  default     = 1
}

variable "redis_allowed_subnet_cidrs" {
  description = "List of CIDRs/subnets which should be able to connect to the Redis cluster"
  type        = "list"
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
  default     = "false"
}

variable "rds_identifier_override" {
  description = "Redis cluster ID. Use only lowercase, numbers and -, _., only use when it needs to be different from var.name"
  default     = ""
}

variable "rds_allowed_subnet_cidrs" {
  description = "List of CIDRs/subnets which should be able to connect to the RDS instance"
  type        = "list"
  default     = ["127.0.0.1/32"]
}

# -------------------------------------------------------------------------------------------------
# RDS instance engine
# -------------------------------------------------------------------------------------------------
variable "rds_engine" {
  description = "RDS instance engine"
  type        = "string"
  default     = "mysql"
}

variable "rds_major_engine_version" {
  description = "RDS instance major engine version"
  type        = "string"
  default     = "5.7"
}

variable "rds_engine_version" {
  description = "RDS instance engine version"
  type        = "string"
  default     = "5.7.19"
}

variable "rds_family" {
  description = "Parameter Group"
  type        = "string"
  default     = "mysql5.7"
}

# -------------------------------------------------------------------------------------------------
# RDS instance node type and replication
# -------------------------------------------------------------------------------------------------
variable "rds_node_type" {
  description = "VM type which should be taken for nodes in the RDS instance"
  type        = "string"
  default     = "db.t3.micro"
}

variable "rds_multi_az" {
  description = "Replication settings"
  type        = "string"
  default     = true
}

# -------------------------------------------------------------------------------------------------
# RDS instance storage settings
# -------------------------------------------------------------------------------------------------
variable "rds_storage_type" {
  description = "Storage type"
  type        = "string"
  default     = "gp2"
}

variable "rds_allocated_storage" {
  description = "Storage size in Gb"
  type        = "string"
  default     = 20
}

# -------------------------------------------------------------------------------------------------
# RDS instance admin user & pass
# -------------------------------------------------------------------------------------------------
variable "rds_admin_user" {
  description = "Admin user name, should default when empty"
  type        = "string"
  default     = "admin"
}

variable "rds_admin_pass" {
  description = "Admin user password. At least 8 characters."
  type        = "string"
  default     = ""
}

variable "rds_use_random_password" {
  description = "with rds_use_random_password set to true the RDS database will be configured with a random password"
  default     = true
}

# -------------------------------------------------------------------------------------------------
# RDS instance settings
# -------------------------------------------------------------------------------------------------
variable "rds_parameter_group_name" {
  description = "Parameter group for database"
  type        = "string"
  default     = ""
}

variable "rds_option_group_name" {
  description = "Option groups for database"
  type        = "string"
  default     = ""
}

# -------------------------------------------------------------------------------------------------
# RDS instance networking
# -------------------------------------------------------------------------------------------------
variable "rds_port" {
  description = "TCP port where DB accept connections"
  type        = "string"
  default     = "3306"
}

variable "rds_db_subnet_group_name" {
  description = "Subnet groups for RDS instance"
  type        = "string"
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
  type        = "string"
  default     = 14
}

variable "rds_deletion_protection" {
  description = "Protect RDS instance from deletion"
  type        = "string"
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = "string"
  default     = false
}

# -------------------------------------------------------------------------------------------------
# RDS instance ecnryption settings
# -------------------------------------------------------------------------------------------------
variable "rds_storage_encrypted" {
  description = "Enable encryption for RDS instance storage"
  type        = "string"
  default     = true
}

variable "rds_kms_key_id" {
  description = "KMS key ARN for storage encryption"
  type        = "string"
  default     = ""
}

variable "rds_maintenance_window" {
  description = "Window of RDS Maintenance"
  type        = "string"
  default     = "Mon:16:00-Mon:18:00"
}

variable "rds_backup_window" {
  description = "Backup window"
  type        = "string"
  default     = "03:00-06:00"
}

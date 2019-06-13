module "ms_sample_redis" {
  source = "../../"

  env  = "playground"
  name = "sample"

  vpc_tag_filter = {
    "Name" = "dev-vpc"
    "env"  = "dev"
  }

  # redis_enabled - Set to false to prevent the module from creating any redis resources
  redis_enabled = true

  # redis_cluster_id_override - Use only lowercase, numbers and -, _., only use when it needs to be different from `var.name`
  # redis_cluster_id_override = ""

  # redis_subnet_tag_filter sets the datasource to match the subnet_id's where the RDS will be located
  redis_subnet_tag_filter = {
    "Name" = "dev-redis-subnet*"
    "env"  = "dev"
  }

  # redis_allowed_subnet_cidrs - List of CIDRs/subnets which should be able to connect to the Redis cluster
  redis_allowed_subnet_cidrs = ["127.0.0.1/32"]

  # redis_shards_count - Number of shards
  redis_shards_count = 1

  # Number of replica nodes in each node group
  redis_replicas_count = 1

  # redis_port - Redis Port
  # redis_port = 6379

  # redis_instance_type - Redis instance type
  redis_instance_type = "cache.t2.micro"

  # redis_group_engine_version - Redis engine version to be used
  # redis_group_engine_version = "5.0.0"

  # redis_group_parameter_group_name - Redis parameter group name"
  # redis_group_parameter_group_name = "default.redis5.0.cluster.on"

  # redis_snapshot_window - Redis snapshot window
  # redis_snapshot_window = "00:00-05:00"

  # redis_maintenance_window - Redis maintenance window
  # redis_maintenance_window = "mon:10:00-mon:12:00"

  # redis_auto_minor_version_upgrade - Redis allow auto minor version upgrade
  # redis_auto_minor_version_upgrade = true

  # redis_at_rest_encryption_enabled - Redis encrypt storage
  redis_at_rest_encryption_enabled = false
  # redis_transit_encryption_enabled - Redis encrypt transit TLS
  # redis_transit_encryption_enabled = false
}


locals {
  redis_cluster_id = length(var.redis_cluster_id_override) > 0 ? var.redis_cluster_id_override : var.name
}

resource "aws_security_group" "allow_redis_communication" {
  count       = var.redis_enabled ? 1 : 0
  vpc_id      = data.aws_vpc.this[0].id
  name        = "allow-communication-with-${local.redis_cluster_id}-redis"
  description = "Allow communication with Redis - ${local.redis_cluster_id}"

  tags = merge(
    {
      "Name" = "allow-communication-with-${local.redis_cluster_id}"
    },
    local.tags,
  )
}

resource "aws_security_group_rule" "redis_ingress" {
  count             = var.redis_enabled ? 1 : 0
  type              = "ingress"
  from_port         = var.redis_port
  to_port           = var.redis_port
  protocol          = "tcp"
  cidr_blocks       = var.redis_allowed_subnet_cidrs
  security_group_id = aws_security_group.allow_redis_communication[0].id
}

resource "aws_elasticache_subnet_group" "this" {
  count = var.redis_enabled ? 1 : 0
  name  = "${local.redis_cluster_id}-redis-subnet-group"

  # IDs of subnets where the cluster should be deployed
  subnet_ids = data.aws_subnet_ids.redis[0].ids
}

resource "aws_elasticache_replication_group" "this" {
  count                         = var.redis_enabled ? 1 : 0
  replication_group_id          = local.redis_cluster_id
  replication_group_description = "${local.redis_cluster_id} - TF Generated"

  # Network configuration
  subnet_group_name  = aws_elasticache_subnet_group.this[0].name
  security_group_ids = [aws_security_group.allow_redis_communication[0].id]

  # Node/VM properties
  node_type = var.redis_instance_type
  port      = var.redis_port

  # Redis configuration
  engine               = "redis"
  engine_version       = var.redis_group_engine_version
  parameter_group_name = var.redis_group_parameter_group_name

  automatic_failover_enabled = true
  multi_az_enabled           = var.redis_multi_az_enabled

  cluster_mode {
    # Number of shards
    num_node_groups = var.redis_shards_count

    # Number of replica nodes in each node group.
    replicas_per_node_group = var.redis_replicas_count
  }

  # Store snapshots for two previous days
  snapshot_retention_limit   = 2
  snapshot_window            = var.redis_snapshot_window
  maintenance_window         = var.redis_maintenance_window
  auto_minor_version_upgrade = var.redis_auto_minor_version_upgrade

  at_rest_encryption_enabled = var.redis_at_rest_encryption_enabled
  transit_encryption_enabled = var.redis_transit_encryption_enabled

  apply_immediately = var.redis_apply_immediately

  tags = merge(
    {
      "Name" = local.redis_cluster_id
    },
    local.tags,
  )
}

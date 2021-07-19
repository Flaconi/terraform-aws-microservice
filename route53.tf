# -------------------------------------------------------------------------------------------------
# Route53 Zones
# -------------------------------------------------------------------------------------------------
locals {
  public_endpoint_enabled  = var.aws_route53_zone_endpoints_enabled && var.aws_route53_zone_public_endpoint_enabled
  private_endpoint_enabled = var.aws_route53_zone_endpoints_enabled && var.aws_route53_zone_private_endpoint_enabled
  subdomain_name           = length(var.aws_route53_rds_subdomain_override) > 0 ? var.aws_route53_rds_subdomain_override : join(".", [module.rds.db_instance_id, local.rds_dns_subdomains[var.rds_engine]])
}

data "aws_route53_zone" "public_endpoint" {
  count        = local.public_endpoint_enabled ? 1 : 0
  name         = var.endpoints_domain
  private_zone = false
}

data "aws_route53_zone" "private_endpoint" {
  count        = local.private_endpoint_enabled ? 1 : 0
  name         = var.endpoints_domain
  private_zone = true
}

# -------------------------------------------------------------------------------------------------
# Route53 Redis Endpoint
# -------------------------------------------------------------------------------------------------
resource "aws_route53_record" "public_redis_endpoint" {
  count   = var.redis_enabled && local.public_endpoint_enabled ? 1 : 0
  name    = "${local.redis_cluster_id}.redis.${var.endpoints_domain}"
  type    = "CNAME"
  ttl     = var.aws_route53_record_ttl
  zone_id = data.aws_route53_zone.public_endpoint[0].zone_id
  records = aws_elasticache_replication_group.this.*.configuration_endpoint_address
}

resource "aws_route53_record" "private_redis_endpoint" {
  count   = var.redis_enabled && local.private_endpoint_enabled ? 1 : 0
  name    = "${local.redis_cluster_id}.redis.${var.endpoints_domain}"
  type    = "CNAME"
  ttl     = var.aws_route53_record_ttl
  zone_id = data.aws_route53_zone.private_endpoint[0].zone_id
  records = aws_elasticache_replication_group.this.*.configuration_endpoint_address
}

# -------------------------------------------------------------------------------------------------
# Route53 RDS Endpoint
# -------------------------------------------------------------------------------------------------
locals {
  rds_dns_subdomains = {
    mysql        = "mysql"
    postgres     = "pgsql"
    sqlserver-se = "sqlserver"
    sqlserver-ee = "sqlserver"
    oracle-se2   = "oracle"
  }
}

resource "aws_route53_record" "public_rds_endpoint" {
  count   = var.rds_enabled && local.public_endpoint_enabled ? 1 : 0
  name    = "${local.subdomain_name}.${var.endpoints_domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.public_endpoint[0].zone_id

  alias {
    name                   = module.rds.db_instance_address
    zone_id                = module.rds.db_instance_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private_rds_endpoint" {
  count   = var.rds_enabled && local.private_endpoint_enabled ? 1 : 0
  name    = "${local.subdomain_name}.${var.endpoints_domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.private_endpoint[0].zone_id

  alias {
    name                   = module.rds.db_instance_address
    zone_id                = module.rds.db_instance_hosted_zone_id
    evaluate_target_health = false
  }
}

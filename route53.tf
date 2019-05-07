# -------------------------------------------------------------------------------------------------
# Route53 Zones
# -------------------------------------------------------------------------------------------------
locals {
  public_endpoint_enabled  = "${var.aws_route53_zone_endpoints_enabled == "true" && var.aws_route53_zone_public_endpoint_enabled == "true"}"
  private_endpoint_enabled = "${var.aws_route53_zone_endpoints_enabled == "true" && var.aws_route53_zone_private_endpoint_enabled == "true"}"
}

data "aws_route53_zone" "public_endpoint" {
  count        = "${local.public_endpoint_enabled ? 1 : 0 }"
  name         = "${var.endpoints_domain}"
  private_zone = false
}

data "aws_route53_zone" "private_endpoint" {
  count        = "${local.private_endpoint_enabled ? 1 : 0 }"
  name         = "${var.endpoints_domain}"
  private_zone = true
}

# -------------------------------------------------------------------------------------------------
# Route53 Redis Endpoint
# -------------------------------------------------------------------------------------------------
resource "aws_route53_record" "public_redis_endpoint" {
  count   = "${var.redis_enabled == "true" && local.public_endpoint_enabled ? 1 : 0 }"
  name    = "${local.redis_cluster_id}.redis.${var.endpoints_domain}"
  type    = "CNAME"
  ttl     = "${var.aws_route53_record_ttl}"
  zone_id = "${data.aws_route53_zone.public_endpoint.zone_id}"
  records = ["${aws_elasticache_replication_group.this.*.configuration_endpoint_addres}"]
}

resource "aws_route53_record" "private_redis_endpoint" {
  count   = "${var.redis_enabled == "true" && local.private_endpoint_enabled ? 1 : 0 }"
  name    = "${local.redis_cluster_id}.redis.${var.endpoints_domain}"
  type    = "CNAME"
  ttl     = "${var.aws_route53_record_ttl}"
  zone_id = "${data.aws_route53_zone.private_endpoint.zone_id}"
  records = ["${aws_elasticache_replication_group.this.*.configuration_endpoint_addres}"]
}

# -------------------------------------------------------------------------------------------------
# Route53 RDS Endpoint
# -------------------------------------------------------------------------------------------------
locals {
  rds_dns_subdomains = {
    mysql    = "mysql"
    postgres = "pgsql"
  }
}

resource "aws_route53_record" "public_rds_endpoint" {
  count   = "${var.rds_enabled == "true" && local.public_endpoint_enabled ? 1 : 0 }"
  name    = "${module.rds.this_db_instance_id}.${lookup(local.rds_dns_subdomains, var.rds_engine)}.${var.endpoints_domain}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.public_endpoint.zone_id}"

  alias {
    name                   = "${module.rds.this_db_instance_address}"
    zone_id                = "${module.rds.this_db_instance_hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private_rds_endpoint" {
  count   = "${var.rds_enabled == "true" && local.private_endpoint_enabled ? 1 : 0 }"
  name    = "${module.rds.this_db_instance_id}.${lookup(local.rds_dns_subdomains, var.rds_engine)}.${var.endpoints_domain}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.private_endpoint.zone_id}"

  alias {
    name                   = "${module.rds.this_db_instance_address}"
    zone_id                = "${module.rds.this_db_instance_hosted_zone_id}"
    evaluate_target_health = false
  }
}

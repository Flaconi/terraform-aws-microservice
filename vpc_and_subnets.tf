data "aws_vpc" "this" {
  count = "${var.redis_enabled == "true" || var.rds_enabled == "true" ? 1 : 0 }"

  tags = "${var.vpc_tag_filter}"
}

data "aws_subnet_ids" "redis" {
  count = "${var.redis_enabled == "true" ? 1 : 0 }"

  vpc_id = "${data.aws_vpc.this.id}"

  tags = "${var.redis_subnet_tag_filter}"
}

data "aws_subnet_ids" "rds" {
  count = "${var.rds_enabled == "true" ? 1 : 0 }"

  vpc_id = "${data.aws_vpc.this.id}"

  tags = "${var.rds_subnet_tag_filter}"
}

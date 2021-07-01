locals {
  tags = merge(
    var.tags,
    {
      "Name"        = "${var.env}-${var.name}"
      "Environment" = var.env
    },
  )
  rds_security_group_ids = concat(
    [module.rds_sg.security_group_id],
    flatten(data.aws_security_groups.for_rds[*].ids),
  )
}

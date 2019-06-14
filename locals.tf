locals {
  tags = merge(
    var.tags,
    {
      "Name"        = "${var.env}-${var.name}"
      "Environment" = var.env
    },
  )
}

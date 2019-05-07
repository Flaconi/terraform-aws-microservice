locals {
  tags = "${merge(var.tags, map(
    "Name", "${var.env}-${var.name}",
    "Environment", "${var.env}"
  ))}"
}

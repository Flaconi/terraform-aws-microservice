locals {
  sqs5_name = length(var.sqs5_name_override) > 0 ? var.sqs5_name_override : join("-", [var.name, "1"])
}

module "sqs5" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  create = var.sqs5_enabled ? "true" : "false"
  name   = local.sqs5_name

  delay_seconds              = var.sqs5_delay_seconds
  fifo_queue                 = var.sqs5_fifo_queue
  max_message_size           = var.sqs5_max_message_size
  receive_wait_time_seconds  = var.sqs5_receive_wait_time_seconds
  redrive_policy             = var.sqs5_redrive_policy
  visibility_timeout_seconds = var.sqs5_visibility_timeout_seconds
}

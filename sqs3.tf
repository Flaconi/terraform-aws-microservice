locals {
  sqs3_name = length(var.sqs3_name_override) > 0 ? var.sqs3_name_override : join("-", [var.name, "1"])
}

module "sqs3" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  create  = var.sqs3_enabled ? "true" : "false"
  name    = local.sqs3_name

  delay_seconds               = var.sqs3_delay_seconds
  fifo_queue                  = var.sqs3_fifo_queue
  max_message_size            = var.sqs3_max_message_size
  receive_wait_time_seconds   = var.sqs3_receive_wait_time_seconds
  redrive_policy              = var.sqs3_redrive_policy
  visibility_timeout_seconds  = var.sqs3_visibility_timeout_seconds
}

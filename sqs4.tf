locals {
  sqs4_name = length(var.sqs4_name_override) > 0 ? var.sqs4_name_override : join("-", [var.name, "4"])
}

module "sqs4" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  create = var.sqs4_enabled ? "true" : "false"
  name   = local.sqs4_name

  delay_seconds              = var.sqs4_delay_seconds
  fifo_queue                 = var.sqs4_fifo_queue
  max_message_size           = var.sqs4_max_message_size
  receive_wait_time_seconds  = var.sqs4_receive_wait_time_seconds
  redrive_policy             = var.sqs4_dlq_enabled ? "{\"deadLetterTargetArn\":\"${module.sqs4-dlq.this_sqs_queue_arn}\",\"maxReceiveCount\":4}" : var.sqs4_redrive_policy
  visibility_timeout_seconds = var.sqs4_visibility_timeout_seconds
}

module "sqs4-dlq" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  create = var.sqs4_dlq_enabled ? "true" : "false"
  name   = "${local.sqs4_name}-deadletter"

  delay_seconds              = var.sqs4_delay_seconds
  max_message_size           = var.sqs4_max_message_size
  receive_wait_time_seconds  = var.sqs4_receive_wait_time_seconds
  visibility_timeout_seconds = var.sqs4_visibility_timeout_seconds
}

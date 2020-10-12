locals {
  sqs1_name = length(var.sqs1_name_override) > 0 ? var.sqs1_name_override : join("-", [var.name, "1"])
}

module "sqs1" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  create = var.sqs1_enabled ? "true" : "false"
  name   = local.sqs1_name

  delay_seconds              = var.sqs1_delay_seconds
  fifo_queue                 = var.sqs1_fifo_queue
  max_message_size           = var.sqs1_max_message_size
  receive_wait_time_seconds  = var.sqs1_receive_wait_time_seconds
  redrive_policy             = var.sqs1_dlq_enabled ? "{\"deadLetterTargetArn\":\"${module.sqs1-dlq.this_sqs_queue_arn}\",\"maxReceiveCount\":4}" : var.sqs1_redrive_policy
  visibility_timeout_seconds = var.sqs1_visibility_timeout_seconds
}

module "sqs1-dlq" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  create = var.sqs1_dlq_enabled ? "true" : "false"
  name   = "${local.sqs1_name}-deadletter"

  delay_seconds              = var.sqs1_delay_seconds
  max_message_size           = var.sqs1_max_message_size
  receive_wait_time_seconds  = var.sqs1_receive_wait_time_seconds
  visibility_timeout_seconds = var.sqs1_visibility_timeout_seconds
}

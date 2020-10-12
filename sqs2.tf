locals {
  sqs2_name = length(var.sqs2_name_override) > 0 ? var.sqs2_name_override : join("-", [var.name, "2"])
}

module "sqs2" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  create = var.sqs2_enabled ? "true" : "false"
  name   = local.sqs2_name

  delay_seconds              = var.sqs2_delay_seconds
  fifo_queue                 = var.sqs2_fifo_queue
  max_message_size           = var.sqs2_max_message_size
  receive_wait_time_seconds  = var.sqs2_receive_wait_time_seconds
  redrive_policy             = var.sqs2_dlq_enabled ? "{\"deadLetterTargetArn\":\"${module.sqs2-dlq.this_sqs_queue_arn}\",\"maxReceiveCount\":4}" : var.sqs2_redrive_policy
  visibility_timeout_seconds = var.sqs2_visibility_timeout_seconds
}

module "sqs2-dlq" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  create = var.sqs2_dlq_enabled ? "true" : "false"
  name   = "${local.sqs2_name}-deadletter"

  delay_seconds              = var.sqs2_delay_seconds
  max_message_size           = var.sqs2_max_message_size
  receive_wait_time_seconds  = var.sqs2_receive_wait_time_seconds
  visibility_timeout_seconds = var.sqs2_visibility_timeout_seconds
}

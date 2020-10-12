module "ms_sample_sqs" {
  source = "../../"

  env  = "playground"
  name = "sample"


  # -------------------------------------------------------------------------------------------------
  # SQS
  # This module re-uses an implementation of the module https://github.com/cloudposse/terraform-aws-sqs
  # -------------------------------------------------------------------------------------------------
  # `sqs_enabled` is set to true to enable SQS
  sqs1_enabled        = true

  tags = {
    Name = "sample"
  }
}

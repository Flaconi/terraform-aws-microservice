module "ms_sample_s3" {
  source = "../../"

  env  = "playground"
  name = "tests3"

  # iam_role_enabled creates a role.
  iam_role_enabled = true

  #s3_enabled    = true
  #kms_enabled   = true
  s3_identifier = "this-is-the-bucket-name"

  tags = {
    Name = "sample"
  }
}

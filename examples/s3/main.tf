module "ms_sample_s3" {
  source = "../../"

  env  = "playground"
  name = "tests3"

  # iam_role_enabled creates a role.
  iam_role_enabled = true

  s3_enabled    = true
  s3_identifier = "this-is-the-bucket-name"

  s3_lifecycle_rules = [
    {
      id              = "all-cleanup"
      status          = "Enabled"
      prefix          = ""
      expiration = {
        days = 90
      }
    },
    {
      id              = "tmp"
      status          = "Enabled"
      prefix          = "tmp/"
      expiration = {
        days = 1
      }
    },
    {
      id              = "MoveAllToGlacierAfterTwoWeeks"
      status          = "Enabled"
      prefix          = ""
      transition = [
        {
          days          = 28
          storage_class = "GLACIER"
        }
      ]
    }
  ]

  tags = {
    Name = "sample"
  }
}

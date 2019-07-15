module "ms_sample_iam" {
  source = "../../"

  env  = "playground"
  name = "sample"

  # iam_user_enabled creates an user with keys, with `iam_role_enabled` the user can switch into the role created by `iam_role_enabled`
  iam_user_enabled = true

  # iam_role_enabled creates a role.
  iam_role_enabled = true

  # Sample principal which can assume into this role
  #iam_role_principals_arns = ["arn:aws:iam::12374567890:root"]

  iam_inline_policies = [
   {
     name = "s3-access"
     statements = [
       {
         actions   = ["s3:ListBucket"]
         resources = ["arn:aws:s3:::test"]
       },
       {
         actions   = ["s3:get*"]
         resources = ["arn:aws:s3:::test/*"]
       }
     ]
   },
   {
     name = "kinesis-full-access"
     statements = [
       {
         actions   = ["kinesis:*"]
         resources = ["*"]
       },
     ]
   }
  ]

  tags = {
    Name = "sample"
  }
}

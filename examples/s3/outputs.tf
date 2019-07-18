output "ms_sample_s3_this_aws_s3_bucket_id" {
  value = module.ms_sample_s3.this_aws_s3_bucket_id
}

output "ms_sample_s3_s3_this_aws_s3_bucket_arn" {
  value = module.ms_sample_s3.this_aws_s3_bucket_arn

}
output "ms_sample_s3_this_iam_role_name" {
  value = module.ms_sample_s3.this_iam_role_name
}

output "ms_sample_s3_this_iam_role_arn" {
  value = module.ms_sample_s3.this_iam_role_arn
}

output "ms_sample_s3_this_aws_iam_access_key" {
  value     = module.ms_sample_s3.this_iam_role_arn
  sensitive = true
}

output "ms_sample_s3_this_aws_iam_access_key_secret" {
  value     = module.ms_sample_s3.this_iam_role_arn
  sensitive = true
}

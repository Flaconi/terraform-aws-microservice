output "ms_sample_iam_this_iam_role_name" {
  value = module.ms_sample_iam.this_iam_role_name
}

output "ms_sample_iam_this_iam_role_arn" {
  value = module.ms_sample_iam.this_iam_role_arn
}

output "ms_sample_iam_this_aws_iam_access_key" {
  value     = module.ms_sample_iam.this_iam_role_arn
  sensitive = true
}

output "ms_sample_iam_this_aws_iam_access_key_secret" {
  value     = module.ms_sample_iam.this_iam_role_arn
  sensitive = true
}

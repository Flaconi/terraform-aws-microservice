output "ms_sample_iam_and_dynamodb_this_iam_role_name" {
  value = module.ms_sample_iam_and_dynamodb.this_iam_role_name
}

output "ms_sample_iam_and_dynamodb_this_iam_role_arn" {
  value = module.ms_sample_iam_and_dynamodb.this_iam_role_arn
}

output "ms_sample_iam_and_dynamodb_this_aws_iam_access_key" {
  value     = module.ms_sample_iam_and_dynamodb.this_iam_role_arn
  sensitive = true
}

output "ms_sample_iam_and_dynamodb_this_aws_iam_access_key_secret" {
  value     = module.ms_sample_iam_and_dynamodb.this_iam_role_arn
  sensitive = true
}

output "ms_sample_iam_and_dynamodb_dynamodb_table_name" {
  value       = module.ms_sample_iam_and_dynamodb.dynamodb_table_name
  description = "DynamoDB table name"
}

output "ms_sample_iam_and_dynamodb_dynamodb_table_id" {
  value       = module.ms_sample_iam_and_dynamodb.dynamodb_table_id
  description = "DynamoDB table ID"
}

output "ms_sample_iam_and_dynamodb_dynamodb_table_arn" {
  value       = module.ms_sample_iam_and_dynamodb.dynamodb_table_arn
  description = "DynamoDB table ARN"
}

output "ms_sample_iam_and_dynamodb_dynamodb_global_secondary_index_names" {
  value       = [module.ms_sample_iam_and_dynamodb.dynamodb_table_arn]
  description = "DynamoDB globl secondary index names"
}

output "ms_sample_iam_and_dynamodb_dynamodb_local_secondary_index_names" {
  value       = [module.ms_sample_iam_and_dynamodb.dynamodb_table_arn]
  description = "DynamoDB local secondary index names"
}

output "ms_sample_iam_and_dynamodb_dynamodb_table_stream_arn" {
  value       = module.ms_sample_iam_and_dynamodb.dynamodb_table_stream_arn
  description = "DynamoDB table stream ARN"
}

output "ms_sample_iam_and_dynamodb_dynamodb_table_stream_label" {
  value       = module.ms_sample_iam_and_dynamodb.dynamodb_table_stream_arn
  description = "DynamoDB table stream label"
}

# -------------------------------------------------------------------------------------------------
# IAM Role
# -------------------------------------------------------------------------------------------------
output "this_iam_role_name" {
  description = "iam role name"
  value       = element(concat(aws_iam_role.this.*.name, [""]), 0)
}

output "this_iam_role_arn" {
  description = "iam role arn"
  value       = element(concat(aws_iam_role.this.*.arn, [""]), 0)
}

# -------------------------------------------------------------------------------------------------
# IAM User
# -------------------------------------------------------------------------------------------------
output "this_user_name" {
  description = "IAM user name"
  value       = element(concat(aws_iam_user.this.*.name, [""]), 0)
}

output "this_user_arn" {
  description = "ARN of the IAM user"
  value       = element(concat(aws_iam_user.this.*.arn, [""]), 0)
}

output "this_aws_iam_access_key" {
  description = "IAM Access Key of the created user"
  value       = element(concat(aws_iam_access_key.this.*.id, [""]), 0)
}

output "this_aws_iam_access_key_secret" {
  description = "The secret key of the user"
  value       = element(concat(aws_iam_access_key.this.*.secret, [""]), 0)
  sensitive   = true
}

# -------------------------------------------------------------------------------------------------
# DynamoDB
# -------------------------------------------------------------------------------------------------
output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_id" {
  description = "DynamoDB table ID"
  value       = module.dynamodb.table_id
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.dynamodb.table_arn
}

output "dynamodb_global_secondary_index_names" {
  description = "DynamoDB secondary index names"
  value       = [module.dynamodb.global_secondary_index_names]
}

output "dynamodb_local_secondary_index_names" {
  description = "DynamoDB local index names"
  value       = [module.dynamodb.local_secondary_index_names]
}

output "dynamodb_table_stream_arn" {
  description = "DynamoDB table stream ARN"
  value       = module.dynamodb.table_stream_arn
}

output "dynamodb_table_stream_label" {
  description = "DynamoDB table stream label"
  value       = module.dynamodb.table_stream_label
}

# -------------------------------------------------------------------------------------------------
# DynamoDB 2
# -------------------------------------------------------------------------------------------------
output "dynamodb2_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb2.table_name
}

output "dynamodb2_table_id" {
  description = "DynamoDB table ID"
  value       = module.dynamodb2.table_id
}

output "dynamodb2_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.dynamodb2.table_arn
}

output "dynamodb2_global_secondary_index_names" {
  description = "DynamoDB secondary index names"
  value       = [module.dynamodb2.global_secondary_index_names]
}

output "dynamodb2_local_secondary_index_names" {
  description = "DynamoDB local index names"
  value       = [module.dynamodb2.local_secondary_index_names]
}

output "dynamodb2_table_stream_arn" {
  description = "DynamoDB table stream ARN"
  value       = module.dynamodb2.table_stream_arn
}

output "dynamodb2_table_stream_label" {
  description = "DynamoDB table stream label"
  value       = module.dynamodb2.table_stream_label
}

# -------------------------------------------------------------------------------------------------
# DynamoDB 3
# -------------------------------------------------------------------------------------------------
output "dynamodb3_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb3.table_name
}

output "dynamodb3_table_id" {
  description = "DynamoDB table ID"
  value       = module.dynamodb3.table_id
}

output "dynamodb3_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.dynamodb3.table_arn
}

output "dynamodb3_global_secondary_index_names" {
  description = "DynamoDB secondary index names"
  value       = [module.dynamodb3.global_secondary_index_names]
}

output "dynamodb3_local_secondary_index_names" {
  description = "DynamoDB local index names"
  value       = [module.dynamodb3.local_secondary_index_names]
}

output "dynamodb3_table_stream_arn" {
  description = "DynamoDB table stream ARN"
  value       = module.dynamodb3.table_stream_arn
}

output "dynamodb3_table_stream_label" {
  description = "DynamoDB table stream label"
  value       = module.dynamodb3.table_stream_label
}



# -------------------------------------------------------------------------------------------------
# Redis
# -------------------------------------------------------------------------------------------------
output "this_redis_subnet_group_id" {
  description = "The AWS elasticache subnet group ID"
  value       = element(concat(aws_elasticache_subnet_group.this.*.id, [""]), 0)
}

output "this_redis_subnet_group_name" {
  description = "The AWS elasticache subnet group name"
  value       = element(concat(aws_elasticache_subnet_group.this.*.name, [""]), 0)
}

# -------------------------------------------------------------------------------------------------
# AWS Elasticache Group - Redis cluster details
# -------------------------------------------------------------------------------------------------
output "this_redis_replication_group_id" {
  description = "The AWS Elasticache replication group ID"
  value       = element(concat(aws_elasticache_replication_group.this.*.id, [""]), 0)
}

output "this_redis_replication_group_replication_group_id" {
  description = "The AWS Elasticache replication group replication group ID"
  value = element(
    concat(
      aws_elasticache_replication_group.this.*.replication_group_id,
      [""],
    ),
    0,
  )
}

output "this_redis_replication_group_number_cache_clusters" {
  description = "The AWS Elasticache replication group number cache clusters"
  value = element(
    concat(
      aws_elasticache_replication_group.this.*.number_cache_clusters,
      [""],
    ),
    0,
  )
}

output "public_redis_endpoint_aws_route53_record" {
  description = "Public Redis cluster end-point address (should be used by the service)"
  value = element(
    concat(aws_route53_record.public_redis_endpoint.*.fqdn, [""]),
    0,
  )
}

output "private_redis_endpoint_aws_route53_record" {
  description = "Private Redis cluster end-point address (should be used by the service)"
  value = element(
    concat(aws_route53_record.private_redis_endpoint.*.fqdn, [""]),
    0,
  )
}

output "redis_port" {
  description = "Redis port"
  value       = var.redis_port
}

# -------------------------------------------------------------------------------------------------
# AWS RDS
# -------------------------------------------------------------------------------------------------
output "rds_this_db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.rds.db_instance_address
}

output "rds_this_db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.rds.db_instance_arn
}

output "rds_this_db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.rds.db_instance_availability_zone
}

output "rds_this_db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_endpoint
}

output "rds_this_db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.rds.db_instance_hosted_zone_id
}

output "rds_this_db_instance_id" {
  description = "The RDS instance ID"
  value       = module.rds.db_instance_id
}

output "rds_this_db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.rds.db_instance_resource_id
}

output "rds_this_db_instance_status" {
  description = "The RDS instance status"
  value       = module.rds.db_instance_status
}

output "rds_this_db_instance_name" {
  description = "The database name"
  value       = module.rds.db_instance_name
}

output "rds_this_db_instance_username" {
  description = "The master username for the database"
  value       = module.rds.db_instance_username
  sensitive   = true
}

output "rds_this_db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.rds.db_instance_password
  sensitive   = true
}

output "rds_this_db_instance_port" {
  description = "The database port"
  value       = module.rds.db_instance_port
}

output "rds_this_db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.rds.db_subnet_group_id
}

output "rds_this_db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.rds.db_subnet_group_arn
}

output "rds_this_db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.rds.db_parameter_group_id
}

output "rds_this_db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.rds.db_parameter_group_arn
}

output "public_rds_endpoint_aws_route53_record" {
  description = "Public Redis cluster end-point address (should be used by the service)"
  value = element(
    concat(aws_route53_record.public_rds_endpoint.*.fqdn, [""]),
    0,
  )
}

output "private_rds_endpoint_aws_route53_record" {
  description = "Private Redis cluster end-point address (should be used by the service)"
  value = element(
    concat(aws_route53_record.private_rds_endpoint.*.fqdn, [""]),
    0,
  )
}


#
# S3
#
output "this_aws_s3_bucket_id" {
  description = "id of created S3 bucket"
  value = element(
    concat(aws_s3_bucket.this.*.id, [""]),
    0,
  )
}

output "this_aws_s3_bucket_arn" {
  description = "id of created S3 bucket"
  value = element(
    concat(aws_s3_bucket.this.*.arn, [""]),
    0,
  )
}

# -------------------------------------------------------------------------------------------------
# SQS 1
# -------------------------------------------------------------------------------------------------
output "sqs1_queue_name" {
  description = "SQS queue name"
  value       = module.sqs1.this_sqs_queue_name
}

output "sqs1_queue_id" {
  description = "SQS queue ID"
  value       = module.sqs1.this_sqs_queue_id
}

output "sqs1_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs1.this_sqs_queue_arn
}

output "sqs1_dlq_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs1-dlq.this_sqs_queue_arn
}

# -------------------------------------------------------------------------------------------------
# SQS 2
# -------------------------------------------------------------------------------------------------
output "sqs2_queue_name" {
  description = "SQS queue name"
  value       = module.sqs2.this_sqs_queue_name
}

output "sqs2_queue_id" {
  description = "SQS queue ID"
  value       = module.sqs2.this_sqs_queue_id
}

output "sqs2_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs2.this_sqs_queue_arn
}

output "sqs2_dlq_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs2-dlq.this_sqs_queue_arn
}

# -------------------------------------------------------------------------------------------------
# SQS 3
# -------------------------------------------------------------------------------------------------
output "sqs3_queue_name" {
  description = "SQS queue name"
  value       = module.sqs3.this_sqs_queue_name
}

output "sqs3_queue_id" {
  description = "SQS queue ID"
  value       = module.sqs3.this_sqs_queue_id
}

output "sqs3_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs3.this_sqs_queue_arn
}

output "sqs3_dlq_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs3-dlq.this_sqs_queue_arn
}

# -------------------------------------------------------------------------------------------------
# SQS 4
# -------------------------------------------------------------------------------------------------
output "sqs4_queue_name" {
  description = "SQS queue name"
  value       = module.sqs4.this_sqs_queue_name
}

output "sqs4_queue_id" {
  description = "SQS queue ID"
  value       = module.sqs4.this_sqs_queue_id
}

output "sqs4_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs4.this_sqs_queue_arn
}

output "sqs4_dlq_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs4-dlq.this_sqs_queue_arn
}

# -------------------------------------------------------------------------------------------------
# SQS 5
# -------------------------------------------------------------------------------------------------
output "sqs5_queue_name" {
  description = "SQS queue name"
  value       = module.sqs5.this_sqs_queue_name
}

output "sqs5_queue_id" {
  description = "SQS queue ID"
  value       = module.sqs5.this_sqs_queue_id
}

output "sqs5_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs5.this_sqs_queue_arn
}

output "sqs5_dlq_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs5-dlq.this_sqs_queue_arn
}

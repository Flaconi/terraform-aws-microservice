output "ms_sample_redis_this_redis_subnet_group_id" {
  value = module.ms_sample_redis.this_redis_subnet_group_id
}

output "ms_sample_redis_this_redis_subnet_group_name" {
  value = module.ms_sample_redis.this_redis_subnet_group_name
}

output "ms_sample_redis_this_redis_replication_group_replication_group_id" {
  value = module.ms_sample_redis.this_redis_replication_group_replication_group_id
}

output "ms_sample_redis_this_redis_replication_group_number_cache_clusters" {
  value = module.ms_sample_redis.this_redis_replication_group_number_cache_clusters
}

output "ms_sample_redis_public_redis_endpoint_aws_route53_record" {
  value = module.ms_sample_redis.public_redis_endpoint_aws_route53_record
}

output "ms_sample_redis_private_redis_endpoint_aws_route53_record" {
  value = module.ms_sample_redis.private_redis_endpoint_aws_route53_record
}

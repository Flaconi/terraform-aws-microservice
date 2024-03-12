# Microservice Boilerplate

[![lint](https://github.com/flaconi/terraform-aws-microservice/workflows/lint/badge.svg)](https://github.com/flaconi/terraform-aws-microservice/actions?query=workflow%3Alint)
[![test](https://github.com/flaconi/terraform-aws-microservice/workflows/test/badge.svg)](https://github.com/flaconi/terraform-aws-microservice/actions?query=workflow%3Atest)
[![Tag](https://img.shields.io/github/tag/flaconi/terraform-aws-microservice.svg)](https://github.com/flaconi/terraform-aws-microservice/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

This Terraform module can create typical resources needed for most microservices.

## Examples

* [DynamoDB](examples/dynamodb/)
* [IAM](examples/iam/)
* [RDS](examples/rds/)
* [Redis](examples/redis/)
* [S3](examples/s3/)
* [SQS](examples/sqs/)

## Usage

### DynamoDB Microservice

```hcl
module "microservice" {
  source = "github.com/flaconi/terraform-aws-microservice"

  env  = "playground"
  name = "sample"

  # iam_user_enabled creates an user with keys, with `iam_role_enabled` the user can switch into the role created by `iam_role_enabled`
  # For this example we're only creating a role with access to Dynamodb
  iam_user_enabled = false

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


  # -------------------------------------------------------------------------------------------------
  # DynamoDB
  # This module re-uses an implementation of the module https://github.com/cloudposse/terraform-aws-dynamodb
  # -------------------------------------------------------------------------------------------------
  # `dynamodb_enabled` is set to true to enable Dynamodb
  dynamodb_enabled = true
  dynamodb_hash_key  = "HashKey"
  dynamodb_range_key = "RangeKey"

  # dynamodb_attributes = []
  # dynamodb_global_secondary_index_map = []
  # dynamodb_local_secondary_index_map = []

  tags = {
    Name = "sample"
  }
}
```

### Redis

```hcl
module "ms_sample_redis" {
  source = "github.com/flaconi/terraform-aws-microservice"

  env  = "playground"
  name = "sample"

  vpc_tag_filter = {
    "Name"= "dev-vpc",
    "env"= "dev"
  }

  # redis_enabled - Set to false to prevent the module from creating any redis resources
  redis_enabled = true

  # redis_cluster_id_override - Use only lowercase, numbers and -, _., only use when it needs to be different from `var.name`
  # redis_cluster_id_override = ""

  # redis_subnet_tag_filter sets the datasource to match the subnet_id's where the RDS will be located
  redis_subnet_tag_filter = {
    "Name" = "dev-redis-subnet*"
    "env"  = "dev"
  }
  # redis_allowed_subnet_cidrs - List of CIDRs/subnets which should be able to connect to the Redis cluster
  redis_allowed_subnet_cidrs = ["127.0.0.1/32"]

  # redis_shards_count - Number of shards
  redis_shards_count = 1

  # Number of replica nodes in each node group
  redis_replicas_count = 1

  # redis_port - Redis Port
  # redis_port = 6379

  # redis_instance_type - Redis instance type
  redis_instance_type = "cache.t2.micro"

  # redis_group_engine_version - Redis engine version to be used
  # redis_group_engine_version = "5.0.0"

  # redis_group_parameter_group_name - Redis parameter group name"
  # redis_group_parameter_group_name = "default.redis5.0.cluster.on"

  # redis_snapshot_window - Redis snapshot window
  # redis_snapshot_window = "00:00-05:00"

  # redis_maintenance_window - Redis maintenance window
  # redis_maintenance_window = "mon:10:00-mon:12:00"

  tags = {
    Name = "sample"
  }
```

### RDS

```hcl
module "ms_sample_rds" {
  source = "github.com/flaconi/terraform-aws-microservice"

  env  = "playground"
  name = "sample"

  vpc_tag_filter = {
    "Name"= "dev-vpc",
    "env"= "dev"
  }

  # rds_subnet_tag_filter sets the datasource to match the subnet_id's where the RDS will be located
  rds_subnet_tag_filter = {
    "Name" = "dev-rds-subnet*"
    "env"  = "dev"
  }

  # rds_enabled enables RDS
  rds_enabled = true

  # rds_allowed_subnet_cidrs specifices the allowed subnets
  #rds_allowed_subnet_cidrs = ["127.0.0.1/32"]

  # rds_admin_user sets the admin user, defaults to admin
  # rds_admin_user          = "demouser"
  # rds_identifier_override overrides the name of the RDS instance, instead of `var.name`
  # rds_identifier_override = "overridename"

  # rds_engine sets the RDS instance engine
  # rds_engine = "mysql"

  # rds_major_engine_version RDS instance major engine version
  # rds_major_engine_version = 5.7

  # rds_family Parameter Group"
  # rds_family = "mysql5.7"

  # rds_node_type sets VM type which should be taken for nodes in the RDS instance
  # rds_node_type = "db.t3.micro"

  # rds_multi_az sets multi-az
  # rds_multi_az = true

  # rds_storage_type sets the RDS storage type
  # rds_storage_type = "gp2"

  # rds_allocated_storage sets the RDS storage size in Gb
  # rds_allocated_storage = "20"

  # rds_admin_pass sets the password in case `rds_admin_pass` is set to false
  # rds_admin_pass = ""

  # rds_use_random_password switched on sets a random password for the rds instance
  # rds_use_random_password = true

  # rds_parameter_group_name Parameter group for database
  # rds_parameter_group_name = ""

  # rds_option_group_name option groups for database
  # rds_option_group_name = ""

  # rds_port TCP port where DB accept connections
  # rds_port = "3306"

  # rds_db_subnet_group_name Subnet groups for RDS instance
  # rds_db_subnet_group_name = ""

  # rds_backup_retention_period Retention period for DB snapshots in days
  rds_backup_retention_period = 14
  # rds_deletion_protection Protect RDS instance from deletion
  rds_deletion_protection = false
  # rds_skip_final_snapshot Protect RDS instance from deletion
  rds_skip_final_snapshot = true
  # rds_storage_encrypted - enable encryption for RDS instance storage"
  rds_storage_encrypted = true
  # rds_kms_key_id - KMS key ARN for storage encryption, defaults to "" = RDS/KMS
  rds_kms_key_id = ""
  # rds_maintenance_window - Window of RDS Maintenance
  rds_maintenance_window = "Mon:16:00-Mon:18:00"
  # rds_backup_window - Backup Window
  rds_backup_window = "03:00-06:00"

  tags = {
    Name = "sample"
  }
}
```

## Resources

The following resources _CAN_ be created:

- 1 IAM Role
- 1 IAM User
- 1 DynamoDB
- 1 RDS Instance
- 1 Policy for accessing Dynamodb from the IAM Role
- 1 Redis cluster with required networking components

<!-- TFDOCS_HEADER_START -->


<!-- TFDOCS_HEADER_END -->

<!-- TFDOCS_PROVIDER_START -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.40 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.2 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6 |

<!-- TFDOCS_PROVIDER_END -->

<!-- TFDOCS_REQUIREMENTS_START -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.40 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

<!-- TFDOCS_REQUIREMENTS_END -->

<!-- TFDOCS_INPUTS_START -->
## Required Inputs

The following input variables are required:

### <a name="input_env"></a> [env](#input\_env)

Description: The environment name to which this project will be applied against (e.g.: common, dev, prod, testing)

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the microservice, the dependent resources will be created with this name interpolated

Type: `string`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to propagate to the resources

Type: `map(any)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_rds_copy_tags_to_snapshot"></a> [rds\_copy\_tags\_to\_snapshot](#input\_rds\_copy\_tags\_to\_snapshot)

Description: On delete, copy all Instance tags to the final snapshot (if final\_snapshot\_identifier is specified)

Type: `bool`

Default: `true`

### <a name="input_vpc_tag_filter"></a> [vpc\_tag\_filter](#input\_vpc\_tag\_filter)

Description: The map of tags to match the VPC tags with where the RDS or Redis or other networked AWS component of the Microservice resides

Type: `map(string)`

Default: `{}`

### <a name="input_additional_sg_names_for_rds"></a> [additional\_sg\_names\_for\_rds](#input\_additional\_sg\_names\_for\_rds)

Description: Name(s) of the additional VPC Security Group(s) to be attached to the RDS instance.

Type: `list(string)`

Default: `[]`

### <a name="input_iam_role_enabled"></a> [iam\_role\_enabled](#input\_iam\_role\_enabled)

Description: Set to false to prevent iam role creation

Type: `bool`

Default: `false`

### <a name="input_iam_role_principals_arns"></a> [iam\_role\_principals\_arns](#input\_iam\_role\_principals\_arns)

Description: List of ARNs to allow assuming the iam role. Could be AWS services or accounts, Kops nodes, IAM users or groups

Type: `list(string)`

Default: `[]`

### <a name="input_iam_user_enabled"></a> [iam\_user\_enabled](#input\_iam\_user\_enabled)

Description: Set to false to prevent iam user creation

Type: `bool`

Default: `false`

### <a name="input_iam_user_path"></a> [iam\_user\_path](#input\_iam\_user\_path)

Description: Set the path for the iam user

Type: `string`

Default: `"/"`

### <a name="input_iam_inline_policies"></a> [iam\_inline\_policies](#input\_iam\_inline\_policies)

Description: Policies applied to the assuming role

Type:

```hcl
list(object({
    name = string
    statements = list(object({
      actions   = list(string)
      resources = list(string)
    }))
  }))
```

Default: `[]`

### <a name="input_aws_route53_record_ttl"></a> [aws\_route53\_record\_ttl](#input\_aws\_route53\_record\_ttl)

Description: Time to live for DNS record used by the endpoints

Type: `string`

Default: `"60"`

### <a name="input_aws_route53_zone_endpoints_enabled"></a> [aws\_route53\_zone\_endpoints\_enabled](#input\_aws\_route53\_zone\_endpoints\_enabled)

Description: To enable the lookup of the domain used for RDS/Redis private endpoint

Type: `bool`

Default: `false`

### <a name="input_aws_route53_zone_public_endpoint_enabled"></a> [aws\_route53\_zone\_public\_endpoint\_enabled](#input\_aws\_route53\_zone\_public\_endpoint\_enabled)

Description: To enable the lookup of the domain used for RDS/Redis public endpoint, we need to set this to true

Type: `bool`

Default: `true`

### <a name="input_aws_route53_zone_private_endpoint_enabled"></a> [aws\_route53\_zone\_private\_endpoint\_enabled](#input\_aws\_route53\_zone\_private\_endpoint\_enabled)

Description: To enable the lookup of the domain used for RDS/Redis private endpoint, we need to set this to true

Type: `bool`

Default: `true`

### <a name="input_endpoints_domain"></a> [endpoints\_domain](#input\_endpoints\_domain)

Description: The domain / route53 zone we need to add a record with

Type: `string`

Default: `""`

### <a name="input_aws_route53_rds_subdomain_override"></a> [aws\_route53\_rds\_subdomain\_override](#input\_aws\_route53\_rds\_subdomain\_override)

Description: To set a custom RDS DNS record subdomain instead of the RDS instance ID

Type: `string`

Default: `""`

### <a name="input_dynamodb_enabled"></a> [dynamodb\_enabled](#input\_dynamodb\_enabled)

Description: Set to false to prevent the module from creating any dynamodb resources

Type: `bool`

Default: `false`

### <a name="input_dynamodb_billing"></a> [dynamodb\_billing](#input\_dynamodb\_billing)

Description: DynamoDB Billing mode. Can be PROVISIONED or PAY\_PER\_REQUEST

Type: `string`

Default: `"PROVISIONED"`

### <a name="input_dynamodb_table_class"></a> [dynamodb\_table\_class](#input\_dynamodb\_table\_class)

Description: Storage class of the table

Type: `string`

Default: `"STANDARD"`

### <a name="input_dynamodb_name_override"></a> [dynamodb\_name\_override](#input\_dynamodb\_name\_override)

Description: define dynamodb\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_dynamodb_hash_key"></a> [dynamodb\_hash\_key](#input\_dynamodb\_hash\_key)

Description: DynamoDB table Hash Key

Type: `string`

Default: `""`

### <a name="input_dynamodb_hash_key_type"></a> [dynamodb\_hash\_key\_type](#input\_dynamodb\_hash\_key\_type)

Description: Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data

Type: `string`

Default: `"S"`

### <a name="input_dynamodb_range_key"></a> [dynamodb\_range\_key](#input\_dynamodb\_range\_key)

Description: DynamoDB table Range Key

Type: `string`

Default: `""`

### <a name="input_dynamodb_range_key_type"></a> [dynamodb\_range\_key\_type](#input\_dynamodb\_range\_key\_type)

Description: Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data

Type: `string`

Default: `"S"`

### <a name="input_dynamodb_attributes"></a> [dynamodb\_attributes](#input\_dynamodb\_attributes)

Description: Additional DynamoDB attributes in the form of a list of mapped values

Type:

```hcl
list(object({
    name = string
    type = string
  }))
```

Default: `[]`

### <a name="input_dynamodb_global_secondary_index_map"></a> [dynamodb\_global\_secondary\_index\_map](#input\_dynamodb\_global\_secondary\_index\_map)

Description: Additional global secondary indexes in the form of a list of mapped values

Type:

```hcl
list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
```

Default: `[]`

### <a name="input_dynamodb_local_secondary_index_map"></a> [dynamodb\_local\_secondary\_index\_map](#input\_dynamodb\_local\_secondary\_index\_map)

Description: Additional local secondary indexes in the form of a list of mapped values

Type:

```hcl
list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
```

Default: `[]`

### <a name="input_dynamodb_autoscale_write_target"></a> [dynamodb\_autoscale\_write\_target](#input\_dynamodb\_autoscale\_write\_target)

Description: The target value for DynamoDB write autoscaling

Type: `number`

Default: `50`

### <a name="input_dynamodb_autoscale_read_target"></a> [dynamodb\_autoscale\_read\_target](#input\_dynamodb\_autoscale\_read\_target)

Description: The target value for DynamoDB read autoscaling

Type: `number`

Default: `50`

### <a name="input_dynamodb_autoscale_min_read_capacity"></a> [dynamodb\_autoscale\_min\_read\_capacity](#input\_dynamodb\_autoscale\_min\_read\_capacity)

Description: DynamoDB autoscaling min read capacity

Type: `number`

Default: `5`

### <a name="input_dynamodb_autoscale_max_read_capacity"></a> [dynamodb\_autoscale\_max\_read\_capacity](#input\_dynamodb\_autoscale\_max\_read\_capacity)

Description: DynamoDB autoscaling max read capacity

Type: `number`

Default: `20`

### <a name="input_dynamodb_autoscale_min_write_capacity"></a> [dynamodb\_autoscale\_min\_write\_capacity](#input\_dynamodb\_autoscale\_min\_write\_capacity)

Description: DynamoDB autoscaling min write capacity

Type: `number`

Default: `5`

### <a name="input_dynamodb_autoscale_max_write_capacity"></a> [dynamodb\_autoscale\_max\_write\_capacity](#input\_dynamodb\_autoscale\_max\_write\_capacity)

Description: DynamoDB autoscaling max write capacity

Type: `number`

Default: `20`

### <a name="input_dynamodb_enable_autoscaler"></a> [dynamodb\_enable\_autoscaler](#input\_dynamodb\_enable\_autoscaler)

Description: Flag to enable/disable DynamoDB autoscaling

Type: `bool`

Default: `true`

### <a name="input_dynamodb2_enabled"></a> [dynamodb2\_enabled](#input\_dynamodb2\_enabled)

Description: Set to false to prevent the module from creating any dynamodb resources

Type: `bool`

Default: `false`

### <a name="input_dynamodb2_billing"></a> [dynamodb2\_billing](#input\_dynamodb2\_billing)

Description: DynamoDB Billing mode. Can be PROVISIONED or PAY\_PER\_REQUEST

Type: `string`

Default: `"PROVISIONED"`

### <a name="input_dynamodb2_table_class"></a> [dynamodb2\_table\_class](#input\_dynamodb2\_table\_class)

Description: Storage class of the table

Type: `string`

Default: `"STANDARD"`

### <a name="input_dynamodb2_name_override"></a> [dynamodb2\_name\_override](#input\_dynamodb2\_name\_override)

Description: define dynamodb2\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_dynamodb2_hash_key"></a> [dynamodb2\_hash\_key](#input\_dynamodb2\_hash\_key)

Description: DynamoDB table Hash Key

Type: `string`

Default: `""`

### <a name="input_dynamodb2_hash_key_type"></a> [dynamodb2\_hash\_key\_type](#input\_dynamodb2\_hash\_key\_type)

Description: Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data

Type: `string`

Default: `"S"`

### <a name="input_dynamodb2_range_key"></a> [dynamodb2\_range\_key](#input\_dynamodb2\_range\_key)

Description: DynamoDB table Range Key

Type: `string`

Default: `""`

### <a name="input_dynamodb2_range_key_type"></a> [dynamodb2\_range\_key\_type](#input\_dynamodb2\_range\_key\_type)

Description: Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data

Type: `string`

Default: `"S"`

### <a name="input_dynamodb2_attributes"></a> [dynamodb2\_attributes](#input\_dynamodb2\_attributes)

Description: Additional DynamoDB attributes in the form of a list of mapped values

Type:

```hcl
list(object({
    name = string
    type = string
  }))
```

Default: `[]`

### <a name="input_dynamodb2_global_secondary_index_map"></a> [dynamodb2\_global\_secondary\_index\_map](#input\_dynamodb2\_global\_secondary\_index\_map)

Description: Additional global secondary indexes in the form of a list of mapped values

Type:

```hcl
list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
```

Default: `[]`

### <a name="input_dynamodb2_local_secondary_index_map"></a> [dynamodb2\_local\_secondary\_index\_map](#input\_dynamodb2\_local\_secondary\_index\_map)

Description: Additional local secondary indexes in the form of a list of mapped values

Type:

```hcl
list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
```

Default: `[]`

### <a name="input_dynamodb2_autoscale_write_target"></a> [dynamodb2\_autoscale\_write\_target](#input\_dynamodb2\_autoscale\_write\_target)

Description: The target value for DynamoDB write autoscaling

Type: `number`

Default: `50`

### <a name="input_dynamodb2_autoscale_read_target"></a> [dynamodb2\_autoscale\_read\_target](#input\_dynamodb2\_autoscale\_read\_target)

Description: The target value for DynamoDB read autoscaling

Type: `number`

Default: `50`

### <a name="input_dynamodb2_autoscale_min_read_capacity"></a> [dynamodb2\_autoscale\_min\_read\_capacity](#input\_dynamodb2\_autoscale\_min\_read\_capacity)

Description: DynamoDB autoscaling min read capacity

Type: `number`

Default: `5`

### <a name="input_dynamodb2_autoscale_max_read_capacity"></a> [dynamodb2\_autoscale\_max\_read\_capacity](#input\_dynamodb2\_autoscale\_max\_read\_capacity)

Description: DynamoDB autoscaling max read capacity

Type: `number`

Default: `20`

### <a name="input_dynamodb2_autoscale_min_write_capacity"></a> [dynamodb2\_autoscale\_min\_write\_capacity](#input\_dynamodb2\_autoscale\_min\_write\_capacity)

Description: DynamoDB autoscaling min write capacity

Type: `number`

Default: `5`

### <a name="input_dynamodb2_autoscale_max_write_capacity"></a> [dynamodb2\_autoscale\_max\_write\_capacity](#input\_dynamodb2\_autoscale\_max\_write\_capacity)

Description: DynamoDB autoscaling max write capacity

Type: `number`

Default: `20`

### <a name="input_dynamodb2_enable_autoscaler"></a> [dynamodb2\_enable\_autoscaler](#input\_dynamodb2\_enable\_autoscaler)

Description: Flag to enable/disable DynamoDB autoscaling

Type: `bool`

Default: `true`

### <a name="input_dynamodb3_enabled"></a> [dynamodb3\_enabled](#input\_dynamodb3\_enabled)

Description: Set to false to prevent the module from creating any dynamodb resources

Type: `bool`

Default: `false`

### <a name="input_dynamodb3_billing"></a> [dynamodb3\_billing](#input\_dynamodb3\_billing)

Description: DynamoDB Billing mode. Can be PROVISIONED or PAY\_PER\_REQUEST

Type: `string`

Default: `"PROVISIONED"`

### <a name="input_dynamodb3_table_class"></a> [dynamodb3\_table\_class](#input\_dynamodb3\_table\_class)

Description: Storage class of the table

Type: `string`

Default: `"STANDARD"`

### <a name="input_dynamodb3_name_override"></a> [dynamodb3\_name\_override](#input\_dynamodb3\_name\_override)

Description: define dynamodb3\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_dynamodb3_hash_key"></a> [dynamodb3\_hash\_key](#input\_dynamodb3\_hash\_key)

Description: DynamoDB table Hash Key

Type: `string`

Default: `""`

### <a name="input_dynamodb3_hash_key_type"></a> [dynamodb3\_hash\_key\_type](#input\_dynamodb3\_hash\_key\_type)

Description: Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data

Type: `string`

Default: `"S"`

### <a name="input_dynamodb3_range_key"></a> [dynamodb3\_range\_key](#input\_dynamodb3\_range\_key)

Description: DynamoDB table Range Key

Type: `string`

Default: `""`

### <a name="input_dynamodb3_range_key_type"></a> [dynamodb3\_range\_key\_type](#input\_dynamodb3\_range\_key\_type)

Description: Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data

Type: `string`

Default: `"S"`

### <a name="input_dynamodb3_attributes"></a> [dynamodb3\_attributes](#input\_dynamodb3\_attributes)

Description: Additional DynamoDB attributes in the form of a list of mapped values

Type:

```hcl
list(object({
    name = string
    type = string
  }))
```

Default: `[]`

### <a name="input_dynamodb3_global_secondary_index_map"></a> [dynamodb3\_global\_secondary\_index\_map](#input\_dynamodb3\_global\_secondary\_index\_map)

Description: Additional global secondary indexes in the form of a list of mapped values

Type:

```hcl
list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
```

Default: `[]`

### <a name="input_dynamodb3_local_secondary_index_map"></a> [dynamodb3\_local\_secondary\_index\_map](#input\_dynamodb3\_local\_secondary\_index\_map)

Description: Additional local secondary indexes in the form of a list of mapped values

Type:

```hcl
list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
```

Default: `[]`

### <a name="input_dynamodb3_autoscale_write_target"></a> [dynamodb3\_autoscale\_write\_target](#input\_dynamodb3\_autoscale\_write\_target)

Description: The target value for DynamoDB write autoscaling

Type: `number`

Default: `50`

### <a name="input_dynamodb3_autoscale_read_target"></a> [dynamodb3\_autoscale\_read\_target](#input\_dynamodb3\_autoscale\_read\_target)

Description: The target value for DynamoDB read autoscaling

Type: `number`

Default: `50`

### <a name="input_dynamodb3_autoscale_min_read_capacity"></a> [dynamodb3\_autoscale\_min\_read\_capacity](#input\_dynamodb3\_autoscale\_min\_read\_capacity)

Description: DynamoDB autoscaling min read capacity

Type: `number`

Default: `5`

### <a name="input_dynamodb3_autoscale_max_read_capacity"></a> [dynamodb3\_autoscale\_max\_read\_capacity](#input\_dynamodb3\_autoscale\_max\_read\_capacity)

Description: DynamoDB autoscaling max read capacity

Type: `number`

Default: `20`

### <a name="input_dynamodb3_autoscale_min_write_capacity"></a> [dynamodb3\_autoscale\_min\_write\_capacity](#input\_dynamodb3\_autoscale\_min\_write\_capacity)

Description: DynamoDB autoscaling min write capacity

Type: `number`

Default: `5`

### <a name="input_dynamodb3_autoscale_max_write_capacity"></a> [dynamodb3\_autoscale\_max\_write\_capacity](#input\_dynamodb3\_autoscale\_max\_write\_capacity)

Description: DynamoDB autoscaling max write capacity

Type: `number`

Default: `20`

### <a name="input_dynamodb3_enable_autoscaler"></a> [dynamodb3\_enable\_autoscaler](#input\_dynamodb3\_enable\_autoscaler)

Description: Flag to enable/disable DynamoDB autoscaling

Type: `bool`

Default: `true`

### <a name="input_dynamodb4_enabled"></a> [dynamodb4\_enabled](#input\_dynamodb4\_enabled)

Description: Set to false to prevent the module from creating any dynamodb resources

Type: `bool`

Default: `false`

### <a name="input_dynamodb4_billing"></a> [dynamodb4\_billing](#input\_dynamodb4\_billing)

Description: DynamoDB Billing mode. Can be PROVISIONED or PAY\_PER\_REQUEST

Type: `string`

Default: `"PROVISIONED"`

### <a name="input_dynamodb4_table_class"></a> [dynamodb4\_table\_class](#input\_dynamodb4\_table\_class)

Description: Storage class of the table

Type: `string`

Default: `"STANDARD"`

### <a name="input_dynamodb4_name_override"></a> [dynamodb4\_name\_override](#input\_dynamodb4\_name\_override)

Description: define dynamodb4\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_dynamodb4_hash_key"></a> [dynamodb4\_hash\_key](#input\_dynamodb4\_hash\_key)

Description: DynamoDB table Hash Key

Type: `string`

Default: `""`

### <a name="input_dynamodb4_hash_key_type"></a> [dynamodb4\_hash\_key\_type](#input\_dynamodb4\_hash\_key\_type)

Description: Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data

Type: `string`

Default: `"S"`

### <a name="input_dynamodb4_range_key"></a> [dynamodb4\_range\_key](#input\_dynamodb4\_range\_key)

Description: DynamoDB table Range Key

Type: `string`

Default: `""`

### <a name="input_dynamodb4_range_key_type"></a> [dynamodb4\_range\_key\_type](#input\_dynamodb4\_range\_key\_type)

Description: Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data

Type: `string`

Default: `"S"`

### <a name="input_dynamodb4_attributes"></a> [dynamodb4\_attributes](#input\_dynamodb4\_attributes)

Description: Additional DynamoDB attributes in the form of a list of mapped values

Type:

```hcl
list(object({
    name = string
    type = string
  }))
```

Default: `[]`

### <a name="input_dynamodb4_global_secondary_index_map"></a> [dynamodb4\_global\_secondary\_index\_map](#input\_dynamodb4\_global\_secondary\_index\_map)

Description: Additional global secondary indexes in the form of a list of mapped values

Type:

```hcl
list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
```

Default: `[]`

### <a name="input_dynamodb4_local_secondary_index_map"></a> [dynamodb4\_local\_secondary\_index\_map](#input\_dynamodb4\_local\_secondary\_index\_map)

Description: Additional local secondary indexes in the form of a list of mapped values

Type:

```hcl
list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
```

Default: `[]`

### <a name="input_dynamodb4_autoscale_write_target"></a> [dynamodb4\_autoscale\_write\_target](#input\_dynamodb4\_autoscale\_write\_target)

Description: The target value for DynamoDB write autoscaling

Type: `number`

Default: `50`

### <a name="input_dynamodb4_autoscale_read_target"></a> [dynamodb4\_autoscale\_read\_target](#input\_dynamodb4\_autoscale\_read\_target)

Description: The target value for DynamoDB read autoscaling

Type: `number`

Default: `50`

### <a name="input_dynamodb4_autoscale_min_read_capacity"></a> [dynamodb4\_autoscale\_min\_read\_capacity](#input\_dynamodb4\_autoscale\_min\_read\_capacity)

Description: DynamoDB autoscaling min read capacity

Type: `number`

Default: `5`

### <a name="input_dynamodb4_autoscale_max_read_capacity"></a> [dynamodb4\_autoscale\_max\_read\_capacity](#input\_dynamodb4\_autoscale\_max\_read\_capacity)

Description: DynamoDB autoscaling max read capacity

Type: `number`

Default: `20`

### <a name="input_dynamodb4_autoscale_min_write_capacity"></a> [dynamodb4\_autoscale\_min\_write\_capacity](#input\_dynamodb4\_autoscale\_min\_write\_capacity)

Description: DynamoDB autoscaling min write capacity

Type: `number`

Default: `5`

### <a name="input_dynamodb4_autoscale_max_write_capacity"></a> [dynamodb4\_autoscale\_max\_write\_capacity](#input\_dynamodb4\_autoscale\_max\_write\_capacity)

Description: DynamoDB autoscaling max write capacity

Type: `number`

Default: `20`

### <a name="input_dynamodb4_enable_autoscaler"></a> [dynamodb4\_enable\_autoscaler](#input\_dynamodb4\_enable\_autoscaler)

Description: Flag to enable/disable DynamoDB autoscaling

Type: `bool`

Default: `true`

### <a name="input_redis_enabled"></a> [redis\_enabled](#input\_redis\_enabled)

Description: Set to false to prevent the module from creating any redis resources

Type: `bool`

Default: `false`

### <a name="input_redis_cluster_id_override"></a> [redis\_cluster\_id\_override](#input\_redis\_cluster\_id\_override)

Description: Redis cluster ID. Use only lowercase, numbers and -, \_., only use when it needs to be different from var.name

Type: `string`

Default: `""`

### <a name="input_redis_port"></a> [redis\_port](#input\_redis\_port)

Description: Redis port

Type: `string`

Default: `"6379"`

### <a name="input_redis_instance_type"></a> [redis\_instance\_type](#input\_redis\_instance\_type)

Description: Redis instance type

Type: `string`

Default: `"cache.m4.large"`

### <a name="input_redis_shards_count"></a> [redis\_shards\_count](#input\_redis\_shards\_count)

Description: Number of shards

Type: `number`

Default: `1`

### <a name="input_redis_group_engine_version"></a> [redis\_group\_engine\_version](#input\_redis\_group\_engine\_version)

Description: Redis engine version to be used

Type: `string`

Default: `"5.0.0"`

### <a name="input_redis_group_parameter_group_name"></a> [redis\_group\_parameter\_group\_name](#input\_redis\_group\_parameter\_group\_name)

Description: Redis parameter group name

Type: `string`

Default: `"default.redis5.0.cluster.on"`

### <a name="input_redis_snapshot_window"></a> [redis\_snapshot\_window](#input\_redis\_snapshot\_window)

Description: Redis snapshot window

Type: `string`

Default: `"00:00-05:00"`

### <a name="input_redis_maintenance_window"></a> [redis\_maintenance\_window](#input\_redis\_maintenance\_window)

Description: Redis snapshot window

Type: `string`

Default: `"mon:10:00-mon:12:00"`

### <a name="input_redis_auto_minor_version_upgrade"></a> [redis\_auto\_minor\_version\_upgrade](#input\_redis\_auto\_minor\_version\_upgrade)

Description: Redis allow auto minor version upgrade

Type: `bool`

Default: `true`

### <a name="input_redis_at_rest_encryption_enabled"></a> [redis\_at\_rest\_encryption\_enabled](#input\_redis\_at\_rest\_encryption\_enabled)

Description: Redis encrypt storage

Type: `bool`

Default: `false`

### <a name="input_redis_transit_encryption_enabled"></a> [redis\_transit\_encryption\_enabled](#input\_redis\_transit\_encryption\_enabled)

Description: Redis encrypt transit TLS

Type: `bool`

Default: `false`

### <a name="input_redis_replicas_count"></a> [redis\_replicas\_count](#input\_redis\_replicas\_count)

Description: Number of replica nodes in each node group

Type: `number`

Default: `1`

### <a name="input_redis_allowed_subnet_cidrs"></a> [redis\_allowed\_subnet\_cidrs](#input\_redis\_allowed\_subnet\_cidrs)

Description: List of CIDRs/subnets which should be able to connect to the Redis cluster

Type: `list(string)`

Default:

```json
[
  "127.0.0.1/32"
]
```

### <a name="input_redis_subnet_tag_filter"></a> [redis\_subnet\_tag\_filter](#input\_redis\_subnet\_tag\_filter)

Description: The Map to filter the subnets of the VPC where the Redis component of the Microservice resides

Type: `map(string)`

Default: `{}`

### <a name="input_redis_subnet_cidr_block_filter"></a> [redis\_subnet\_cidr\_block\_filter](#input\_redis\_subnet\_cidr\_block\_filter)

Description: List of CIDR blocks to filter subnets of the VPC where the Redis component of the Microservice resides

Type: `list(string)`

Default: `[]`

### <a name="input_redis_apply_immediately"></a> [redis\_apply\_immediately](#input\_redis\_apply\_immediately)

Description: Specifies whether any modifications are applied immediately, or during the next maintenance window.

Type: `bool`

Default: `false`

### <a name="input_redis_multi_az_enabled"></a> [redis\_multi\_az\_enabled](#input\_redis\_multi\_az\_enabled)

Description: Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic\_failover\_enabled must also be enabled.

Type: `bool`

Default: `false`

### <a name="input_rds_apply_immediately"></a> [rds\_apply\_immediately](#input\_rds\_apply\_immediately)

Description: Specifies whether any database modifications are applied immediately, or during the next maintenance window

Type: `bool`

Default: `false`

### <a name="input_rds_enabled"></a> [rds\_enabled](#input\_rds\_enabled)

Description: Set to false to prevent the module from creating any rds resources

Type: `bool`

Default: `false`

### <a name="input_rds_enable_s3_dump"></a> [rds\_enable\_s3\_dump](#input\_rds\_enable\_s3\_dump)

Description: Set to true to allow the module to create RDS DB dump resources.

Type: `bool`

Default: `false`

### <a name="input_rds_s3_dump_name_prefix"></a> [rds\_s3\_dump\_name\_prefix](#input\_rds\_s3\_dump\_name\_prefix)

Description: The S3 name prefix

Type: `string`

Default: `""`

### <a name="input_rds_s3_dump_allowed_ips"></a> [rds\_s3\_dump\_allowed\_ips](#input\_rds\_s3\_dump\_allowed\_ips)

Description: List of CIDRs allowed to access data on the S3 bucket for RDS DB dumps

Type: `list(string)`

Default: `[]`

### <a name="input_rds_s3_kms_dump_key_additional_role_arns"></a> [rds\_s3\_kms\_dump\_key\_additional\_role\_arns](#input\_rds\_s3\_kms\_dump\_key\_additional\_role\_arns)

Description: List of IAM role ARNs that are able to access the KMS key used for encrypting RDS dump files in the S3 bucket

Type: `list(string)`

Default: `[]`

### <a name="input_rds_s3_dump_role_arn"></a> [rds\_s3\_dump\_role\_arn](#input\_rds\_s3\_dump\_role\_arn)

Description: IAM role ARN to be associated with the RDS instance, for being able to access the S3 dump bucket(s). If this is set, the module will not create the role nor its policy but instead will directly associate the RDS instance with passed role. If this is not set, the module will handle the creation of the IAM policy and the role itself.

Type: `string`

Default: `""`

### <a name="input_rds_s3_dump_lifecycle_rules"></a> [rds\_s3\_dump\_lifecycle\_rules](#input\_rds\_s3\_dump\_lifecycle\_rules)

Description: RDS S3 Dump Lifecycle rules

Type:

```hcl
list(object({
    id     = string
    status = optional(string, "Enabled")
    prefix = string
    expiration = optional(list(object({
      days                         = optional(number)
      date                         = optional(string)
      expired_object_delete_marker = optional(bool)
    })), [])
    transition = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })), [])
  }))
```

Default: `[]`

### <a name="input_rds_identifier_override"></a> [rds\_identifier\_override](#input\_rds\_identifier\_override)

Description: RDS identifier override. Use only lowercase, numbers and -, \_., only use when it needs to be different from var.name

Type: `string`

Default: `""`

### <a name="input_rds_dbname_override"></a> [rds\_dbname\_override](#input\_rds\_dbname\_override)

Description: RDS DB Name override in case the identifier is not wished as db name

Type: `string`

Default: `""`

### <a name="input_rds_allowed_subnet_cidrs"></a> [rds\_allowed\_subnet\_cidrs](#input\_rds\_allowed\_subnet\_cidrs)

Description: List of CIDRs/subnets which should be able to connect to the RDS instance

Type: `list(string)`

Default:

```json
[
  "127.0.0.1/32"
]
```

### <a name="input_rds_timeouts"></a> [rds\_timeouts](#input\_rds\_timeouts)

Description: (Optional) Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times

Type: `map(string)`

Default:

```json
{
  "create": "40m",
  "delete": "40m",
  "update": "80m"
}
```

### <a name="input_rds_option_group_timeouts"></a> [rds\_option\_group\_timeouts](#input\_rds\_option\_group\_timeouts)

Description: Define maximum timeout for deletion of `aws_db_option_group` resource

Type: `map(string)`

Default:

```json
{
  "delete": "15m"
}
```

### <a name="input_rds_engine"></a> [rds\_engine](#input\_rds\_engine)

Description: RDS instance engine

Type: `string`

Default: `"mysql"`

### <a name="input_rds_major_engine_version"></a> [rds\_major\_engine\_version](#input\_rds\_major\_engine\_version)

Description: RDS instance major engine version

Type: `string`

Default: `"5.7"`

### <a name="input_rds_auto_minor_version_upgrade"></a> [rds\_auto\_minor\_version\_upgrade](#input\_rds\_auto\_minor\_version\_upgrade)

Description: Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window

Type: `bool`

Default: `false`

### <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version)

Description: RDS instance engine version

Type: `string`

Default: `"5.7.19"`

### <a name="input_rds_family"></a> [rds\_family](#input\_rds\_family)

Description: Parameter Group

Type: `string`

Default: `"mysql5.7"`

### <a name="input_rds_node_type"></a> [rds\_node\_type](#input\_rds\_node\_type)

Description: VM type which should be taken for nodes in the RDS instance

Type: `string`

Default: `"db.t3.micro"`

### <a name="input_rds_multi_az"></a> [rds\_multi\_az](#input\_rds\_multi\_az)

Description: Replication settings

Type: `bool`

Default: `true`

### <a name="input_rds_storage_type"></a> [rds\_storage\_type](#input\_rds\_storage\_type)

Description: Storage type

Type: `string`

Default: `"gp2"`

### <a name="input_rds_allocated_storage"></a> [rds\_allocated\_storage](#input\_rds\_allocated\_storage)

Description: Storage size in Gb

Type: `string`

Default: `20`

### <a name="input_rds_max_allocated_storage"></a> [rds\_max\_allocated\_storage](#input\_rds\_max\_allocated\_storage)

Description: Specifies the value for Storage Autoscaling

Type: `number`

Default: `0`

### <a name="input_rds_iops"></a> [rds\_iops](#input\_rds\_iops)

Description: The amount of provisioned IOPS. Setting this implies a storage\_type of 'io1'

Type: `number`

Default: `0`

### <a name="input_rds_admin_user"></a> [rds\_admin\_user](#input\_rds\_admin\_user)

Description: Admin user name, should default when empty

Type: `string`

Default: `"admin"`

### <a name="input_rds_admin_pass"></a> [rds\_admin\_pass](#input\_rds\_admin\_pass)

Description: Admin user password. At least 8 characters.

Type: `string`

Default: `""`

### <a name="input_rds_use_random_password"></a> [rds\_use\_random\_password](#input\_rds\_use\_random\_password)

Description: with rds\_use\_random\_password set to true the RDS database will be configured with a random password

Type: `bool`

Default: `true`

### <a name="input_rds_iam_database_authentication_enabled"></a> [rds\_iam\_database\_authentication\_enabled](#input\_rds\_iam\_database\_authentication\_enabled)

Description: Enable / disable IAM database authentication

Type: `string`

Default: `"false"`

### <a name="input_rds_parameter_group_name"></a> [rds\_parameter\_group\_name](#input\_rds\_parameter\_group\_name)

Description: Parameter group for database

Type: `string`

Default: `""`

### <a name="input_rds_parameters"></a> [rds\_parameters](#input\_rds\_parameters)

Description: List of RDS parameters to apply

Type: `list(map(string))`

Default: `[]`

### <a name="input_rds_option_group_name"></a> [rds\_option\_group\_name](#input\_rds\_option\_group\_name)

Description: Option groups for database

Type: `string`

Default: `""`

### <a name="input_rds_options"></a> [rds\_options](#input\_rds\_options)

Description: A list of RDS Options to apply

Type: `any`

Default: `[]`

### <a name="input_rds_ca_cert_identifier"></a> [rds\_ca\_cert\_identifier](#input\_rds\_ca\_cert\_identifier)

Description: The identifier of the CA certificate for the DB instance.

Type: `string`

Default: `"rds-ca-2019"`

### <a name="input_rds_license_model"></a> [rds\_license\_model](#input\_rds\_license\_model)

Description: License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1

Type: `string`

Default: `""`

### <a name="input_rds_enabled_cloudwatch_logs_exports"></a> [rds\_enabled\_cloudwatch\_logs\_exports](#input\_rds\_enabled\_cloudwatch\_logs\_exports)

Description: List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL).

Type: `list(string)`

Default: `[]`

### <a name="input_rds_performance_insights_enabled"></a> [rds\_performance\_insights\_enabled](#input\_rds\_performance\_insights\_enabled)

Description: Specifies whether Performance Insights are enabled

Type: `bool`

Default: `false`

### <a name="input_rds_performance_insights_retention_period"></a> [rds\_performance\_insights\_retention\_period](#input\_rds\_performance\_insights\_retention\_period)

Description: The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years).

Type: `number`

Default: `7`

### <a name="input_rds_enhanced_monitoring_interval"></a> [rds\_enhanced\_monitoring\_interval](#input\_rds\_enhanced\_monitoring\_interval)

Description: The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60.

Type: `number`

Default: `0`

### <a name="input_rds_db_subnet_group_description"></a> [rds\_db\_subnet\_group\_description](#input\_rds\_db\_subnet\_group\_description)

Description: Description of the DB subnet group to create

Type: `string`

Default: `""`

### <a name="input_rds_parameter_group_description"></a> [rds\_parameter\_group\_description](#input\_rds\_parameter\_group\_description)

Description: Description of the DB parameter group to create

Type: `string`

Default: `""`

### <a name="input_rds_option_group_description"></a> [rds\_option\_group\_description](#input\_rds\_option\_group\_description)

Description: The description of the option group

Type: `string`

Default: `""`

### <a name="input_rds_option_group_use_name_prefix"></a> [rds\_option\_group\_use\_name\_prefix](#input\_rds\_option\_group\_use\_name\_prefix)

Description: Determines whether to use `option_group_name` as is or create a unique name beginning with the `option_group_name` as the prefix

Type: `bool`

Default: `true`

### <a name="input_rds_port"></a> [rds\_port](#input\_rds\_port)

Description: TCP port where DB accept connections

Type: `string`

Default: `"3306"`

### <a name="input_rds_db_subnet_group_name"></a> [rds\_db\_subnet\_group\_name](#input\_rds\_db\_subnet\_group\_name)

Description: Subnet groups for RDS instance

Type: `string`

Default: `""`

### <a name="input_rds_subnet_tag_filter"></a> [rds\_subnet\_tag\_filter](#input\_rds\_subnet\_tag\_filter)

Description: The Map to filter the subnets of the VPC where the RDS component of the Microservice resides

Type: `map(string)`

Default: `{}`

### <a name="input_rds_subnet_cidr_block_filter"></a> [rds\_subnet\_cidr\_block\_filter](#input\_rds\_subnet\_cidr\_block\_filter)

Description: List of CIDR blocks to filter subnets of the VPC where the RDS component of the Microservice resides

Type: `list(string)`

Default: `[]`

### <a name="input_rds_final_snapshot_identifier_override"></a> [rds\_final\_snapshot\_identifier\_override](#input\_rds\_final\_snapshot\_identifier\_override)

Description: RDS final snapshot identifier override.

Type: `string`

Default: `""`

### <a name="input_rds_db_snapshot_name"></a> [rds\_db\_snapshot\_name](#input\_rds\_db\_snapshot\_name)

Description: Specifies whether or not to create this database from a snapshot.

Type: `string`

Default: `""`

### <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period)

Description: Retention period for DB snapshots in days

Type: `string`

Default: `14`

### <a name="input_rds_deletion_protection"></a> [rds\_deletion\_protection](#input\_rds\_deletion\_protection)

Description: Protect RDS instance from deletion

Type: `bool`

Default: `true`

### <a name="input_rds_skip_final_snapshot"></a> [rds\_skip\_final\_snapshot](#input\_rds\_skip\_final\_snapshot)

Description: Skip final snapshot on deletion

Type: `bool`

Default: `false`

### <a name="input_rds_storage_encrypted"></a> [rds\_storage\_encrypted](#input\_rds\_storage\_encrypted)

Description: Enable encryption for RDS instance storage

Type: `bool`

Default: `true`

### <a name="input_rds_kms_key_id"></a> [rds\_kms\_key\_id](#input\_rds\_kms\_key\_id)

Description: KMS key ARN for storage encryption

Type: `string`

Default: `""`

### <a name="input_rds_maintenance_window"></a> [rds\_maintenance\_window](#input\_rds\_maintenance\_window)

Description: Window of RDS Maintenance

Type: `string`

Default: `"Mon:16:00-Mon:18:00"`

### <a name="input_rds_backup_window"></a> [rds\_backup\_window](#input\_rds\_backup\_window)

Description: Backup window

Type: `string`

Default: `"03:00-06:00"`

### <a name="input_s3_enabled"></a> [s3\_enabled](#input\_s3\_enabled)

Description: S3 bucket creation and iam policy creation enabled

Type: `bool`

Default: `false`

### <a name="input_s3_identifier"></a> [s3\_identifier](#input\_s3\_identifier)

Description: The S3 Bucket name

Type: `string`

Default: `""`

### <a name="input_s3_force_destroy"></a> [s3\_force\_destroy](#input\_s3\_force\_destroy)

Description: S3 Force destroy

Type: `bool`

Default: `true`

### <a name="input_s3_versioning_enabled"></a> [s3\_versioning\_enabled](#input\_s3\_versioning\_enabled)

Description: S3 Versioning enabled

Type: `string`

Default: `"Enabled"`

### <a name="input_s3_lifecycle_rules"></a> [s3\_lifecycle\_rules](#input\_s3\_lifecycle\_rules)

Description: S3 Lifecycle rules

Type:

```hcl
list(object({
    id     = string
    status = optional(string, "Enabled")
    prefix = string
    expiration = optional(list(object({
      days                         = optional(number)
      date                         = optional(string)
      expired_object_delete_marker = optional(bool)
    })), [])
    transition = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })), [])
  }))
```

Default: `[]`

### <a name="input_sqs1_enabled"></a> [sqs1\_enabled](#input\_sqs1\_enabled)

Description: Set to false to prevent the module from creating any sqs resources

Type: `bool`

Default: `false`

### <a name="input_sqs1_name_override"></a> [sqs1\_name\_override](#input\_sqs1\_name\_override)

Description: define sqs1\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_sqs1_delay_seconds"></a> [sqs1\_delay\_seconds](#input\_sqs1\_delay\_seconds)

Description: define sqs1\_delay\_seconds

Type: `number`

Default: `0`

### <a name="input_sqs1_fifo_queue"></a> [sqs1\_fifo\_queue](#input\_sqs1\_fifo\_queue)

Description: Boolean designating a FIFO queue

Type: `bool`

Default: `false`

### <a name="input_sqs1_max_message_size"></a> [sqs1\_max\_message\_size](#input\_sqs1\_max\_message\_size)

Description: The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)

Type: `number`

Default: `262144`

### <a name="input_sqs1_receive_wait_time_seconds"></a> [sqs1\_receive\_wait\_time\_seconds](#input\_sqs1\_receive\_wait\_time\_seconds)

Description: The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)

Type: `number`

Default: `0`

### <a name="input_sqs1_redrive_policy"></a> [sqs1\_redrive\_policy](#input\_sqs1\_redrive\_policy)

Description: The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5")

Type: `string`

Default: `""`

### <a name="input_sqs1_visibility_timeout_seconds"></a> [sqs1\_visibility\_timeout\_seconds](#input\_sqs1\_visibility\_timeout\_seconds)

Description: The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)

Type: `number`

Default: `30`

### <a name="input_sqs1_dlq_enabled"></a> [sqs1\_dlq\_enabled](#input\_sqs1\_dlq\_enabled)

Description: Set to false to prevent the module from creating any sqs-dql resources

Type: `bool`

Default: `false`

### <a name="input_sqs2_enabled"></a> [sqs2\_enabled](#input\_sqs2\_enabled)

Description: Set to false to prevent the module from creating any sqs resources

Type: `bool`

Default: `false`

### <a name="input_sqs2_name_override"></a> [sqs2\_name\_override](#input\_sqs2\_name\_override)

Description: define sqs2\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_sqs2_delay_seconds"></a> [sqs2\_delay\_seconds](#input\_sqs2\_delay\_seconds)

Description: define sqs2\_delay\_seconds

Type: `number`

Default: `0`

### <a name="input_sqs2_fifo_queue"></a> [sqs2\_fifo\_queue](#input\_sqs2\_fifo\_queue)

Description: Boolean designating a FIFO queue

Type: `bool`

Default: `false`

### <a name="input_sqs2_max_message_size"></a> [sqs2\_max\_message\_size](#input\_sqs2\_max\_message\_size)

Description: The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)

Type: `number`

Default: `262144`

### <a name="input_sqs2_receive_wait_time_seconds"></a> [sqs2\_receive\_wait\_time\_seconds](#input\_sqs2\_receive\_wait\_time\_seconds)

Description: The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)

Type: `number`

Default: `0`

### <a name="input_sqs2_redrive_policy"></a> [sqs2\_redrive\_policy](#input\_sqs2\_redrive\_policy)

Description: The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5")

Type: `string`

Default: `""`

### <a name="input_sqs2_visibility_timeout_seconds"></a> [sqs2\_visibility\_timeout\_seconds](#input\_sqs2\_visibility\_timeout\_seconds)

Description: The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)

Type: `number`

Default: `30`

### <a name="input_sqs2_dlq_enabled"></a> [sqs2\_dlq\_enabled](#input\_sqs2\_dlq\_enabled)

Description: Set to false to prevent the module from creating any sqs-dql resources

Type: `bool`

Default: `false`

### <a name="input_sqs3_enabled"></a> [sqs3\_enabled](#input\_sqs3\_enabled)

Description: Set to false to prevent the module from creating any sqs resources

Type: `bool`

Default: `false`

### <a name="input_sqs3_name_override"></a> [sqs3\_name\_override](#input\_sqs3\_name\_override)

Description: define sqs3\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_sqs3_delay_seconds"></a> [sqs3\_delay\_seconds](#input\_sqs3\_delay\_seconds)

Description: define sqs3\_delay\_seconds

Type: `number`

Default: `0`

### <a name="input_sqs3_fifo_queue"></a> [sqs3\_fifo\_queue](#input\_sqs3\_fifo\_queue)

Description: Boolean designating a FIFO queue

Type: `bool`

Default: `false`

### <a name="input_sqs3_max_message_size"></a> [sqs3\_max\_message\_size](#input\_sqs3\_max\_message\_size)

Description: The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)

Type: `number`

Default: `262144`

### <a name="input_sqs3_receive_wait_time_seconds"></a> [sqs3\_receive\_wait\_time\_seconds](#input\_sqs3\_receive\_wait\_time\_seconds)

Description: The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)

Type: `number`

Default: `0`

### <a name="input_sqs3_redrive_policy"></a> [sqs3\_redrive\_policy](#input\_sqs3\_redrive\_policy)

Description: The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5")

Type: `string`

Default: `""`

### <a name="input_sqs3_visibility_timeout_seconds"></a> [sqs3\_visibility\_timeout\_seconds](#input\_sqs3\_visibility\_timeout\_seconds)

Description: The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)

Type: `number`

Default: `30`

### <a name="input_sqs3_dlq_enabled"></a> [sqs3\_dlq\_enabled](#input\_sqs3\_dlq\_enabled)

Description: Set to false to prevent the module from creating any sqs-dql resources

Type: `bool`

Default: `false`

### <a name="input_sqs4_enabled"></a> [sqs4\_enabled](#input\_sqs4\_enabled)

Description: Set to false to prevent the module from creating any sqs resources

Type: `bool`

Default: `false`

### <a name="input_sqs4_name_override"></a> [sqs4\_name\_override](#input\_sqs4\_name\_override)

Description: define sqs4\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_sqs4_delay_seconds"></a> [sqs4\_delay\_seconds](#input\_sqs4\_delay\_seconds)

Description: define sqs4\_delay\_seconds

Type: `number`

Default: `0`

### <a name="input_sqs4_fifo_queue"></a> [sqs4\_fifo\_queue](#input\_sqs4\_fifo\_queue)

Description: Boolean designating a FIFO queue

Type: `bool`

Default: `false`

### <a name="input_sqs4_max_message_size"></a> [sqs4\_max\_message\_size](#input\_sqs4\_max\_message\_size)

Description: The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)

Type: `number`

Default: `262144`

### <a name="input_sqs4_receive_wait_time_seconds"></a> [sqs4\_receive\_wait\_time\_seconds](#input\_sqs4\_receive\_wait\_time\_seconds)

Description: The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)

Type: `number`

Default: `0`

### <a name="input_sqs4_redrive_policy"></a> [sqs4\_redrive\_policy](#input\_sqs4\_redrive\_policy)

Description: The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5")

Type: `string`

Default: `""`

### <a name="input_sqs4_visibility_timeout_seconds"></a> [sqs4\_visibility\_timeout\_seconds](#input\_sqs4\_visibility\_timeout\_seconds)

Description: The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)

Type: `number`

Default: `30`

### <a name="input_sqs4_dlq_enabled"></a> [sqs4\_dlq\_enabled](#input\_sqs4\_dlq\_enabled)

Description: Set to false to prevent the module from creating any sqs-dql resources

Type: `bool`

Default: `false`

### <a name="input_sqs5_enabled"></a> [sqs5\_enabled](#input\_sqs5\_enabled)

Description: Set to false to prevent the module from creating any sqs resources

Type: `bool`

Default: `false`

### <a name="input_sqs5_name_override"></a> [sqs5\_name\_override](#input\_sqs5\_name\_override)

Description: define sqs5\_name\_override to set a name differnt from var.name

Type: `string`

Default: `""`

### <a name="input_sqs5_delay_seconds"></a> [sqs5\_delay\_seconds](#input\_sqs5\_delay\_seconds)

Description: define sqs5\_delay\_seconds

Type: `number`

Default: `0`

### <a name="input_sqs5_fifo_queue"></a> [sqs5\_fifo\_queue](#input\_sqs5\_fifo\_queue)

Description: Boolean designating a FIFO queue

Type: `bool`

Default: `false`

### <a name="input_sqs5_max_message_size"></a> [sqs5\_max\_message\_size](#input\_sqs5\_max\_message\_size)

Description: The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)

Type: `number`

Default: `262144`

### <a name="input_sqs5_receive_wait_time_seconds"></a> [sqs5\_receive\_wait\_time\_seconds](#input\_sqs5\_receive\_wait\_time\_seconds)

Description: The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)

Type: `number`

Default: `0`

### <a name="input_sqs5_redrive_policy"></a> [sqs5\_redrive\_policy](#input\_sqs5\_redrive\_policy)

Description: The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5")

Type: `string`

Default: `""`

### <a name="input_sqs5_visibility_timeout_seconds"></a> [sqs5\_visibility\_timeout\_seconds](#input\_sqs5\_visibility\_timeout\_seconds)

Description: The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)

Type: `number`

Default: `30`

### <a name="input_sqs5_dlq_enabled"></a> [sqs5\_dlq\_enabled](#input\_sqs5\_dlq\_enabled)

Description: Set to false to prevent the module from creating any sqs-dql resources

Type: `bool`

Default: `false`

<!-- TFDOCS_INPUTS_END -->

<!-- TFDOCS_OUTPUTS_START -->
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb2_global_secondary_index_names"></a> [dynamodb2\_global\_secondary\_index\_names](#output\_dynamodb2\_global\_secondary\_index\_names) | DynamoDB secondary index names |
| <a name="output_dynamodb2_local_secondary_index_names"></a> [dynamodb2\_local\_secondary\_index\_names](#output\_dynamodb2\_local\_secondary\_index\_names) | DynamoDB local index names |
| <a name="output_dynamodb2_table_arn"></a> [dynamodb2\_table\_arn](#output\_dynamodb2\_table\_arn) | DynamoDB table ARN |
| <a name="output_dynamodb2_table_id"></a> [dynamodb2\_table\_id](#output\_dynamodb2\_table\_id) | DynamoDB table ID |
| <a name="output_dynamodb2_table_name"></a> [dynamodb2\_table\_name](#output\_dynamodb2\_table\_name) | DynamoDB table name |
| <a name="output_dynamodb2_table_stream_arn"></a> [dynamodb2\_table\_stream\_arn](#output\_dynamodb2\_table\_stream\_arn) | DynamoDB table stream ARN |
| <a name="output_dynamodb2_table_stream_label"></a> [dynamodb2\_table\_stream\_label](#output\_dynamodb2\_table\_stream\_label) | DynamoDB table stream label |
| <a name="output_dynamodb3_global_secondary_index_names"></a> [dynamodb3\_global\_secondary\_index\_names](#output\_dynamodb3\_global\_secondary\_index\_names) | DynamoDB secondary index names |
| <a name="output_dynamodb3_local_secondary_index_names"></a> [dynamodb3\_local\_secondary\_index\_names](#output\_dynamodb3\_local\_secondary\_index\_names) | DynamoDB local index names |
| <a name="output_dynamodb3_table_arn"></a> [dynamodb3\_table\_arn](#output\_dynamodb3\_table\_arn) | DynamoDB table ARN |
| <a name="output_dynamodb3_table_id"></a> [dynamodb3\_table\_id](#output\_dynamodb3\_table\_id) | DynamoDB table ID |
| <a name="output_dynamodb3_table_name"></a> [dynamodb3\_table\_name](#output\_dynamodb3\_table\_name) | DynamoDB table name |
| <a name="output_dynamodb3_table_stream_arn"></a> [dynamodb3\_table\_stream\_arn](#output\_dynamodb3\_table\_stream\_arn) | DynamoDB table stream ARN |
| <a name="output_dynamodb3_table_stream_label"></a> [dynamodb3\_table\_stream\_label](#output\_dynamodb3\_table\_stream\_label) | DynamoDB table stream label |
| <a name="output_dynamodb4_global_secondary_index_names"></a> [dynamodb4\_global\_secondary\_index\_names](#output\_dynamodb4\_global\_secondary\_index\_names) | DynamoDB secondary index names |
| <a name="output_dynamodb4_local_secondary_index_names"></a> [dynamodb4\_local\_secondary\_index\_names](#output\_dynamodb4\_local\_secondary\_index\_names) | DynamoDB local index names |
| <a name="output_dynamodb4_table_arn"></a> [dynamodb4\_table\_arn](#output\_dynamodb4\_table\_arn) | DynamoDB table ARN |
| <a name="output_dynamodb4_table_id"></a> [dynamodb4\_table\_id](#output\_dynamodb4\_table\_id) | DynamoDB table ID |
| <a name="output_dynamodb4_table_name"></a> [dynamodb4\_table\_name](#output\_dynamodb4\_table\_name) | DynamoDB table name |
| <a name="output_dynamodb4_table_stream_arn"></a> [dynamodb4\_table\_stream\_arn](#output\_dynamodb4\_table\_stream\_arn) | DynamoDB table stream ARN |
| <a name="output_dynamodb4_table_stream_label"></a> [dynamodb4\_table\_stream\_label](#output\_dynamodb4\_table\_stream\_label) | DynamoDB table stream label |
| <a name="output_dynamodb_global_secondary_index_names"></a> [dynamodb\_global\_secondary\_index\_names](#output\_dynamodb\_global\_secondary\_index\_names) | DynamoDB secondary index names |
| <a name="output_dynamodb_local_secondary_index_names"></a> [dynamodb\_local\_secondary\_index\_names](#output\_dynamodb\_local\_secondary\_index\_names) | DynamoDB local index names |
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | DynamoDB table ARN |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | DynamoDB table ID |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | DynamoDB table name |
| <a name="output_dynamodb_table_stream_arn"></a> [dynamodb\_table\_stream\_arn](#output\_dynamodb\_table\_stream\_arn) | DynamoDB table stream ARN |
| <a name="output_dynamodb_table_stream_label"></a> [dynamodb\_table\_stream\_label](#output\_dynamodb\_table\_stream\_label) | DynamoDB table stream label |
| <a name="output_private_rds_endpoint_aws_route53_record"></a> [private\_rds\_endpoint\_aws\_route53\_record](#output\_private\_rds\_endpoint\_aws\_route53\_record) | Private Redis cluster end-point address (should be used by the service) |
| <a name="output_private_redis_endpoint_aws_route53_record"></a> [private\_redis\_endpoint\_aws\_route53\_record](#output\_private\_redis\_endpoint\_aws\_route53\_record) | Private Redis cluster end-point address (should be used by the service) |
| <a name="output_public_rds_endpoint_aws_route53_record"></a> [public\_rds\_endpoint\_aws\_route53\_record](#output\_public\_rds\_endpoint\_aws\_route53\_record) | Public Redis cluster end-point address (should be used by the service) |
| <a name="output_public_redis_endpoint_aws_route53_record"></a> [public\_redis\_endpoint\_aws\_route53\_record](#output\_public\_redis\_endpoint\_aws\_route53\_record) | Public Redis cluster end-point address (should be used by the service) |
| <a name="output_rds_this_db_instance_address"></a> [rds\_this\_db\_instance\_address](#output\_rds\_this\_db\_instance\_address) | The address of the RDS instance |
| <a name="output_rds_this_db_instance_arn"></a> [rds\_this\_db\_instance\_arn](#output\_rds\_this\_db\_instance\_arn) | The ARN of the RDS instance |
| <a name="output_rds_this_db_instance_availability_zone"></a> [rds\_this\_db\_instance\_availability\_zone](#output\_rds\_this\_db\_instance\_availability\_zone) | The availability zone of the RDS instance |
| <a name="output_rds_this_db_instance_endpoint"></a> [rds\_this\_db\_instance\_endpoint](#output\_rds\_this\_db\_instance\_endpoint) | The connection endpoint |
| <a name="output_rds_this_db_instance_hosted_zone_id"></a> [rds\_this\_db\_instance\_hosted\_zone\_id](#output\_rds\_this\_db\_instance\_hosted\_zone\_id) | The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record) |
| <a name="output_rds_this_db_instance_identifier"></a> [rds\_this\_db\_instance\_identifier](#output\_rds\_this\_db\_instance\_identifier) | The RDS instance Identifier |
| <a name="output_rds_this_db_instance_name"></a> [rds\_this\_db\_instance\_name](#output\_rds\_this\_db\_instance\_name) | The database name |
| <a name="output_rds_this_db_instance_password"></a> [rds\_this\_db\_instance\_password](#output\_rds\_this\_db\_instance\_password) | The database password (this password may be old, because Terraform doesn't track it after initial creation) |
| <a name="output_rds_this_db_instance_port"></a> [rds\_this\_db\_instance\_port](#output\_rds\_this\_db\_instance\_port) | The database port |
| <a name="output_rds_this_db_instance_resource_id"></a> [rds\_this\_db\_instance\_resource\_id](#output\_rds\_this\_db\_instance\_resource\_id) | The RDS Resource ID of this instance |
| <a name="output_rds_this_db_instance_status"></a> [rds\_this\_db\_instance\_status](#output\_rds\_this\_db\_instance\_status) | The RDS instance status |
| <a name="output_rds_this_db_instance_username"></a> [rds\_this\_db\_instance\_username](#output\_rds\_this\_db\_instance\_username) | The master username for the database |
| <a name="output_rds_this_db_parameter_group_arn"></a> [rds\_this\_db\_parameter\_group\_arn](#output\_rds\_this\_db\_parameter\_group\_arn) | The ARN of the db parameter group |
| <a name="output_rds_this_db_parameter_group_id"></a> [rds\_this\_db\_parameter\_group\_id](#output\_rds\_this\_db\_parameter\_group\_id) | The db parameter group id |
| <a name="output_rds_this_db_subnet_group_arn"></a> [rds\_this\_db\_subnet\_group\_arn](#output\_rds\_this\_db\_subnet\_group\_arn) | The ARN of the db subnet group |
| <a name="output_rds_this_db_subnet_group_id"></a> [rds\_this\_db\_subnet\_group\_id](#output\_rds\_this\_db\_subnet\_group\_id) | The db subnet group name |
| <a name="output_redis_port"></a> [redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_sqs1_dlq_queue_arn"></a> [sqs1\_dlq\_queue\_arn](#output\_sqs1\_dlq\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs1_queue_arn"></a> [sqs1\_queue\_arn](#output\_sqs1\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs1_queue_id"></a> [sqs1\_queue\_id](#output\_sqs1\_queue\_id) | SQS queue ID |
| <a name="output_sqs1_queue_name"></a> [sqs1\_queue\_name](#output\_sqs1\_queue\_name) | SQS queue name |
| <a name="output_sqs2_dlq_queue_arn"></a> [sqs2\_dlq\_queue\_arn](#output\_sqs2\_dlq\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs2_queue_arn"></a> [sqs2\_queue\_arn](#output\_sqs2\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs2_queue_id"></a> [sqs2\_queue\_id](#output\_sqs2\_queue\_id) | SQS queue ID |
| <a name="output_sqs2_queue_name"></a> [sqs2\_queue\_name](#output\_sqs2\_queue\_name) | SQS queue name |
| <a name="output_sqs3_dlq_queue_arn"></a> [sqs3\_dlq\_queue\_arn](#output\_sqs3\_dlq\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs3_queue_arn"></a> [sqs3\_queue\_arn](#output\_sqs3\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs3_queue_id"></a> [sqs3\_queue\_id](#output\_sqs3\_queue\_id) | SQS queue ID |
| <a name="output_sqs3_queue_name"></a> [sqs3\_queue\_name](#output\_sqs3\_queue\_name) | SQS queue name |
| <a name="output_sqs4_dlq_queue_arn"></a> [sqs4\_dlq\_queue\_arn](#output\_sqs4\_dlq\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs4_queue_arn"></a> [sqs4\_queue\_arn](#output\_sqs4\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs4_queue_id"></a> [sqs4\_queue\_id](#output\_sqs4\_queue\_id) | SQS queue ID |
| <a name="output_sqs4_queue_name"></a> [sqs4\_queue\_name](#output\_sqs4\_queue\_name) | SQS queue name |
| <a name="output_sqs5_dlq_queue_arn"></a> [sqs5\_dlq\_queue\_arn](#output\_sqs5\_dlq\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs5_queue_arn"></a> [sqs5\_queue\_arn](#output\_sqs5\_queue\_arn) | SQS queue ARN |
| <a name="output_sqs5_queue_id"></a> [sqs5\_queue\_id](#output\_sqs5\_queue\_id) | SQS queue ID |
| <a name="output_sqs5_queue_name"></a> [sqs5\_queue\_name](#output\_sqs5\_queue\_name) | SQS queue name |
| <a name="output_this_aws_iam_access_key"></a> [this\_aws\_iam\_access\_key](#output\_this\_aws\_iam\_access\_key) | IAM Access Key of the created user |
| <a name="output_this_aws_iam_access_key_secret"></a> [this\_aws\_iam\_access\_key\_secret](#output\_this\_aws\_iam\_access\_key\_secret) | The secret key of the user |
| <a name="output_this_aws_s3_bucket_arn"></a> [this\_aws\_s3\_bucket\_arn](#output\_this\_aws\_s3\_bucket\_arn) | id of created S3 bucket |
| <a name="output_this_aws_s3_bucket_id"></a> [this\_aws\_s3\_bucket\_id](#output\_this\_aws\_s3\_bucket\_id) | id of created S3 bucket |
| <a name="output_this_iam_role_arn"></a> [this\_iam\_role\_arn](#output\_this\_iam\_role\_arn) | iam role arn |
| <a name="output_this_iam_role_name"></a> [this\_iam\_role\_name](#output\_this\_iam\_role\_name) | iam role name |
| <a name="output_this_redis_replication_group_id"></a> [this\_redis\_replication\_group\_id](#output\_this\_redis\_replication\_group\_id) | The AWS Elasticache replication group ID |
| <a name="output_this_redis_replication_group_number_cache_clusters"></a> [this\_redis\_replication\_group\_number\_cache\_clusters](#output\_this\_redis\_replication\_group\_number\_cache\_clusters) | The AWS Elasticache replication group number cache clusters |
| <a name="output_this_redis_replication_group_replication_group_id"></a> [this\_redis\_replication\_group\_replication\_group\_id](#output\_this\_redis\_replication\_group\_replication\_group\_id) | The AWS Elasticache replication group replication group ID |
| <a name="output_this_redis_subnet_group_id"></a> [this\_redis\_subnet\_group\_id](#output\_this\_redis\_subnet\_group\_id) | The AWS elasticache subnet group ID |
| <a name="output_this_redis_subnet_group_name"></a> [this\_redis\_subnet\_group\_name](#output\_this\_redis\_subnet\_group\_name) | The AWS elasticache subnet group name |
| <a name="output_this_user_arn"></a> [this\_user\_arn](#output\_this\_user\_arn) | ARN of the IAM user |
| <a name="output_this_user_name"></a> [this\_user\_name](#output\_this\_user\_name) | IAM user name |

<!-- TFDOCS_OUTPUTS_END -->

## License

[MIT](LICENSE)

Copyright (c) 2019-2022 [Flaconi GmbH](https://github.com/Flaconi)

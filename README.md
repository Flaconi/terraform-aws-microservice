# Microservice Boilerplate

[![Build Status](https://travis-ci.com/Flaconi/terraform-aws-microservice.svg?branch=master)](https://travis-ci.com/Flaconi/terraform-aws-microservice)
[![Tag](https://img.shields.io/github/tag/Flaconi/terraform-aws-microservice.svg)](https://github.com/Flaconi/terraform-aws-microservice/releases)
<!-- [![Terraform](https://img.shields.io/badge/Terraform--registry-aws--iam--roles-brightgreen.svg)](https://registry.terraform.io/modules/Flaconi/microservice/aws/) -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

This Terraform module can create typical resources needed for most microservices.

## Examples

* [DynamoDB](examples/dynamodb/)
* [IAM](examples/iam/)
* [RDS](examples/rds/)
* [Redis](examples/redis/)

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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| env | The environment name to which this project will be applied against (e.g.: common, dev, prod, testing) | string | n/a | yes |
| name | The name of the microservice, the dependent resources will be created with this name interpolated | string | n/a | yes |
| tags | tags to propagate to the resources | map(any) | n/a | yes |
| aws\_route53\_record\_ttl | Time to live for DNS record used by the endpoints | string | `"60"` | no |
| aws\_route53\_zone\_endpoints\_enabled | To enable the lookup of the domain used for RDS/Redis private endpoint | string | `"false"` | no |
| aws\_route53\_zone\_private\_endpoint\_enabled | To enable the lookup of the domain used for RDS/Redis private endpoint, we need to set this to true | string | `"true"` | no |
| aws\_route53\_zone\_public\_endpoint\_enabled | To enable the lookup of the domain used for RDS/Redis public endpoint, we need to set this to true | string | `"true"` | no |
| dynamodb2\_attributes | Additional DynamoDB attributes in the form of a list of mapped values | list | `[]` | no |
| dynamodb2\_autoscale\_max\_read\_capacity | DynamoDB autoscaling max read capacity | number | `"20"` | no |
| dynamodb2\_autoscale\_max\_write\_capacity | DynamoDB autoscaling max write capacity | number | `"20"` | no |
| dynamodb2\_autoscale\_min\_read\_capacity | DynamoDB autoscaling min read capacity | number | `"5"` | no |
| dynamodb2\_autoscale\_min\_write\_capacity | DynamoDB autoscaling min write capacity | number | `"5"` | no |
| dynamodb2\_autoscale\_read\_target | The target value for DynamoDB read autoscaling | number | `"50"` | no |
| dynamodb2\_autoscale\_write\_target | The target value for DynamoDB write autoscaling | number | `"50"` | no |
| dynamodb2\_enable\_autoscaler | Flag to enable/disable DynamoDB autoscaling | bool | `"true"` | no |
| dynamodb2\_enabled | Set to false to prevent the module from creating any dynamodb resources | string | `"false"` | no |
| dynamodb2\_global\_secondary\_index\_map | Additional global secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb2\_hash\_key | DynamoDB table Hash Key | string | `""` | no |
| dynamodb2\_hash\_key\_type | Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `"S"` | no |
| dynamodb2\_local\_secondary\_index\_map | Additional local secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb2\_name\_override | define dynamodb2_name_override to set a name differnt from var.name | string | `""` | no |
| dynamodb2\_range\_key | DynamoDB table Range Key | string | `""` | no |
| dynamodb2\_range\_key\_type | Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `"S"` | no |
| dynamodb3\_attributes | Additional DynamoDB attributes in the form of a list of mapped values | list | `[]` | no |
| dynamodb3\_autoscale\_max\_read\_capacity | DynamoDB autoscaling max read capacity | number | `"20"` | no |
| dynamodb3\_autoscale\_max\_write\_capacity | DynamoDB autoscaling max write capacity | number | `"20"` | no |
| dynamodb3\_autoscale\_min\_read\_capacity | DynamoDB autoscaling min read capacity | number | `"5"` | no |
| dynamodb3\_autoscale\_min\_write\_capacity | DynamoDB autoscaling min write capacity | number | `"5"` | no |
| dynamodb3\_autoscale\_read\_target | The target value for DynamoDB read autoscaling | number | `"50"` | no |
| dynamodb3\_autoscale\_write\_target | The target value for DynamoDB write autoscaling | number | `"50"` | no |
| dynamodb3\_enable\_autoscaler | Flag to enable/disable DynamoDB autoscaling | bool | `"true"` | no |
| dynamodb3\_enabled | Set to false to prevent the module from creating any dynamodb resources | string | `"false"` | no |
| dynamodb3\_global\_secondary\_index\_map | Additional global secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb3\_hash\_key | DynamoDB table Hash Key | string | `""` | no |
| dynamodb3\_hash\_key\_type | Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `"S"` | no |
| dynamodb3\_local\_secondary\_index\_map | Additional local secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb3\_name\_override | define dynamodb3_name_override to set a name differnt from var.name | string | `""` | no |
| dynamodb3\_range\_key | DynamoDB table Range Key | string | `""` | no |
| dynamodb3\_range\_key\_type | Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `"S"` | no |
| dynamodb\_attributes | Additional DynamoDB attributes in the form of a list of mapped values | list | `[]` | no |
| dynamodb\_autoscale\_max\_read\_capacity | DynamoDB autoscaling max read capacity | number | `"20"` | no |
| dynamodb\_autoscale\_max\_write\_capacity | DynamoDB autoscaling max write capacity | number | `"20"` | no |
| dynamodb\_autoscale\_min\_read\_capacity | DynamoDB autoscaling min read capacity | number | `"5"` | no |
| dynamodb\_autoscale\_min\_write\_capacity | DynamoDB autoscaling min write capacity | number | `"5"` | no |
| dynamodb\_autoscale\_read\_target | The target value for DynamoDB read autoscaling | number | `"50"` | no |
| dynamodb\_autoscale\_write\_target | The target value for DynamoDB write autoscaling | number | `"50"` | no |
| dynamodb\_enable\_autoscaler | Flag to enable/disable DynamoDB autoscaling | bool | `"true"` | no |
| dynamodb\_enabled | Set to false to prevent the module from creating any dynamodb resources | string | `"false"` | no |
| dynamodb\_global\_secondary\_index\_map | Additional global secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb\_hash\_key | DynamoDB table Hash Key | string | `""` | no |
| dynamodb\_hash\_key\_type | Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `"S"` | no |
| dynamodb\_local\_secondary\_index\_map | Additional local secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb\_name\_override | define dynamodb_name_override to set a name differnt from var.name | string | `""` | no |
| dynamodb\_range\_key | DynamoDB table Range Key | string | `""` | no |
| dynamodb\_range\_key\_type | Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `"S"` | no |
| endpoints\_domain | The domain / route53 zone we need to add a record with | string | `""` | no |
| iam\_inline\_policies | Policies applied to the assuming role | list | `[]` | no |
| iam\_role\_enabled | Set to false to prevent iam role creation | string | `"false"` | no |
| iam\_role\_principals\_arns | List of ARNs to allow assuming the iam role. Could be AWS services or accounts, Kops nodes, IAM users or groups | list(string) | `[]` | no |
| iam\_user\_enabled | Set to false to prevent iam user creation | string | `"false"` | no |
| iam\_user\_path | Set the path for the iam user | string | `"/"` | no |
| rds\_admin\_pass | Admin user password. At least 8 characters. | string | `""` | no |
| rds\_admin\_user | Admin user name, should default when empty | string | `"admin"` | no |
| rds\_allocated\_storage | Storage size in Gb | string | `"20"` | no |
| rds\_allowed\_subnet\_cidrs | List of CIDRs/subnets which should be able to connect to the RDS instance | list(string) | `[ "127.0.0.1/32" ]` | no |
| rds\_backup\_retention\_period | Retention period for DB snapshots in days | string | `"14"` | no |
| rds\_backup\_window | Backup window | string | `"03:00-06:00"` | no |
| rds\_db\_subnet\_group\_name | Subnet groups for RDS instance | string | `""` | no |
| rds\_dbname\_override | RDS DB Name override in case the identifier is not wished as db name | string | `""` | no |
| rds\_deletion\_protection | Protect RDS instance from deletion | string | `"true"` | no |
| rds\_enabled | Set to false to prevent the module from creating any rds resources | string | `"false"` | no |
| rds\_engine | RDS instance engine | string | `"mysql"` | no |
| rds\_engine\_version | RDS instance engine version | string | `"5.7.19"` | no |
| rds\_family | Parameter Group | string | `"mysql5.7"` | no |
| rds\_iam\_database\_authentication\_enabled | Enable / disable IAM database authentication | string | `"false"` | no |
| rds\_identifier\_override | RDS identifier override. Use only lowercase, numbers and -, _., only use when it needs to be different from var.name | string | `""` | no |
| rds\_kms\_key\_id | KMS key ARN for storage encryption | string | `""` | no |
| rds\_maintenance\_window | Window of RDS Maintenance | string | `"Mon:16:00-Mon:18:00"` | no |
| rds\_major\_engine\_version | RDS instance major engine version | string | `"5.7"` | no |
| rds\_multi\_az | Replication settings | string | `"true"` | no |
| rds\_node\_type | VM type which should be taken for nodes in the RDS instance | string | `"db.t3.micro"` | no |
| rds\_option\_group\_name | Option groups for database | string | `""` | no |
| rds\_parameter\_group\_name | Parameter group for database | string | `""` | no |
| rds\_port | TCP port where DB accept connections | string | `"3306"` | no |
| rds\_skip\_final\_snapshot | Skip final snapshot on deletion | string | `"false"` | no |
| rds\_storage\_encrypted | Enable encryption for RDS instance storage | string | `"true"` | no |
| rds\_storage\_type | Storage type | string | `"gp2"` | no |
| rds\_subnet\_tag\_filter | The Map to filter the subnets of the VPC where the RDS component of the Microservice resides | map | `{}` | no |
| rds\_use\_random\_password | with rds_use_random_password set to true the RDS database will be configured with a random password | string | `"true"` | no |
| redis\_allowed\_subnet\_cidrs | List of CIDRs/subnets which should be able to connect to the Redis cluster | list(string) | `[ "127.0.0.1/32" ]` | no |
| redis\_at\_rest\_encryption\_enabled | Redis encrypt storage | string | `"false"` | no |
| redis\_auto\_minor\_version\_upgrade | Redis allow auto minor version upgrade | string | `"true"` | no |
| redis\_cluster\_id\_override | Redis cluster ID. Use only lowercase, numbers and -, _., only use when it needs to be different from var.name | string | `""` | no |
| redis\_enabled | Set to false to prevent the module from creating any redis resources | string | `"false"` | no |
| redis\_group\_engine\_version | Redis engine version to be used | string | `"5.0.0"` | no |
| redis\_group\_parameter\_group\_name | Redis parameter group name | string | `"default.redis5.0.cluster.on"` | no |
| redis\_instance\_type | Redis instance type | string | `"cache.m4.large"` | no |
| redis\_maintenance\_window | Redis snapshot window | string | `"mon:10:00-mon:12:00"` | no |
| redis\_port | Redis port | string | `"6379"` | no |
| redis\_replicas\_count | Number of replica nodes in each node group | string | `"1"` | no |
| redis\_shards\_count | Number of shards | string | `"1"` | no |
| redis\_snapshot\_window | Redis snapshot window | string | `"00:00-05:00"` | no |
| redis\_subnet\_tag\_filter | The Map to filter the subnets of the VPC where the Redis component of the Microservice resides | map | `{}` | no |
| redis\_transit\_encryption\_enabled | Redis encrypt transit TLS | string | `"false"` | no |
| s3\_enabled | S3 bucket creation and iam policy creation enabled | bool | `"false"` | no |
| s3\_force\_destroy | S3 Force destroy | bool | `"true"` | no |
| s3\_identifier | The S3 Bucket name | string | `""` | no |
| s3\_versioning\_enabled | S3 Versioning enabled | bool | `"true"` | no |
| vpc\_tag\_filter | The map of tags to match the VPC tags with where the RDS or Redis or other networked AWS component of the Microservice resides | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| dynamodb2\_global\_secondary\_index\_names | DynamoDB secondary index names |
| dynamodb2\_local\_secondary\_index\_names | DynamoDB local index names |
| dynamodb2\_table\_arn | DynamoDB table ARN |
| dynamodb2\_table\_id | DynamoDB table ID |
| dynamodb2\_table\_name | DynamoDB table name |
| dynamodb2\_table\_stream\_arn | DynamoDB table stream ARN |
| dynamodb2\_table\_stream\_label | DynamoDB table stream label |
| dynamodb3\_global\_secondary\_index\_names | DynamoDB secondary index names |
| dynamodb3\_local\_secondary\_index\_names | DynamoDB local index names |
| dynamodb3\_table\_arn | DynamoDB table ARN |
| dynamodb3\_table\_id | DynamoDB table ID |
| dynamodb3\_table\_name | DynamoDB table name |
| dynamodb3\_table\_stream\_arn | DynamoDB table stream ARN |
| dynamodb3\_table\_stream\_label | DynamoDB table stream label |
| dynamodb\_global\_secondary\_index\_names | DynamoDB secondary index names |
| dynamodb\_local\_secondary\_index\_names | DynamoDB local index names |
| dynamodb\_table\_arn | DynamoDB table ARN |
| dynamodb\_table\_id | DynamoDB table ID |
| dynamodb\_table\_name | DynamoDB table name |
| dynamodb\_table\_stream\_arn | DynamoDB table stream ARN |
| dynamodb\_table\_stream\_label | DynamoDB table stream label |
| private\_rds\_endpoint\_aws\_route53\_record | Private Redis cluster end-point address (should be used by the service) |
| private\_redis\_endpoint\_aws\_route53\_record | Private Redis cluster end-point address (should be used by the service) |
| public\_rds\_endpoint\_aws\_route53\_record | Public Redis cluster end-point address (should be used by the service) |
| public\_redis\_endpoint\_aws\_route53\_record | Public Redis cluster end-point address (should be used by the service) |
| rds\_this\_db\_instance\_address | The address of the RDS instance |
| rds\_this\_db\_instance\_arn | The ARN of the RDS instance |
| rds\_this\_db\_instance\_availability\_zone | The availability zone of the RDS instance |
| rds\_this\_db\_instance\_endpoint | The connection endpoint |
| rds\_this\_db\_instance\_hosted\_zone\_id | The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record) |
| rds\_this\_db\_instance\_id | The RDS instance ID |
| rds\_this\_db\_instance\_name | The database name |
| rds\_this\_db\_instance\_password | The database password (this password may be old, because Terraform doesn't track it after initial creation) |
| rds\_this\_db\_instance\_port | The database port |
| rds\_this\_db\_instance\_resource\_id | The RDS Resource ID of this instance |
| rds\_this\_db\_instance\_status | The RDS instance status |
| rds\_this\_db\_instance\_username | The master username for the database |
| rds\_this\_db\_parameter\_group\_arn | The ARN of the db parameter group |
| rds\_this\_db\_parameter\_group\_id | The db parameter group id |
| rds\_this\_db\_subnet\_group\_arn | The ARN of the db subnet group |
| rds\_this\_db\_subnet\_group\_id | The db subnet group name |
| redis\_port | Redis port |
| this\_aws\_iam\_access\_key | IAM Access Key of the created user |
| this\_aws\_iam\_access\_key\_secret | The secret key of the user |
| this\_aws\_s3\_bucket\_arn | id of created S3 bucket |
| this\_aws\_s3\_bucket\_id | id of created S3 bucket |
| this\_iam\_role\_arn | iam role arn |
| this\_iam\_role\_name | iam role name |
| this\_redis\_replication\_group\_id | The AWS Elasticache replication group ID |
| this\_redis\_replication\_group\_number\_cache\_clusters | The AWS Elasticache replication group number cache clusters |
| this\_redis\_replication\_group\_replication\_group\_id | The AWS Elasticache replication group replication group ID |
| this\_redis\_subnet\_group\_id | The AWS elasticache subnet group ID |
| this\_redis\_subnet\_group\_name | The AWS elasticache subnet group name |
| this\_user\_arn | ARN of the IAM user |
| this\_user\_name | IAM user name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## License

[MIT](LICENSE)

Copyright (c) 2019 [Flaconi GmbH](https://github.com/Flaconi)

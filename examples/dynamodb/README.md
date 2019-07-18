# DynamoDB

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
| dynamodb2\_enabled | Set to false to prevent the module from creating any dynamodb resources | string | `"false"` | no |
| dynamodb2\_global\_secondary\_index\_map | Additional global secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb2\_hash\_key | DynamoDB table Hash Key | string | `""` | no |
| dynamodb2\_local\_secondary\_index\_map | Additional local secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb2\_name\_override | define dynamodb2_name_override to set a name differnt from var.name | string | `""` | no |
| dynamodb2\_range\_key | DynamoDB table Range Key | string | `""` | no |
| dynamodb\_attributes | Additional DynamoDB attributes in the form of a list of mapped values | list | `[]` | no |
| dynamodb\_enabled | Set to false to prevent the module from creating any dynamodb resources | string | `"false"` | no |
| dynamodb\_global\_secondary\_index\_map | Additional global secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb\_hash\_key | DynamoDB table Hash Key | string | `""` | no |
| dynamodb\_local\_secondary\_index\_map | Additional local secondary indexes in the form of a list of mapped values | object | `[]` | no |
| dynamodb\_name\_override | define dynamodb_name_override to set a name differnt from var.name | string | `""` | no |
| dynamodb\_range\_key | DynamoDB table Range Key | string | `""` | no |
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

# Simple ECS Service Example

This example demonstrates how to use the ECS service collection module to create a basic ECS service with Fargate launch type.

## Purpose

This example creates a simple ECS service running an nginx container using Fargate, along with the necessary prerequisites like cluster, task definition, execution role, and security group.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS region | string | "us-west-2" | no |
| cluster_name | Name of the ECS cluster | string | "simple-ecs-cluster" | no |
| execution_role_name | Name of the ECS execution role | string | "simple-ecs-execution-role" | no |
| task_family | Family name for the task definition | string | "simple-task" | no |
| service_name | Name of the ECS service | string | "simple-ecs-service" | no |
| desired_count | Desired number of tasks | number | 1 | no |
| tags | Tags to apply to resources | map(string) | {...} | no |

## Outputs

| Name | Description |
|------|-------------|
| ecs_service_id | The ID of the ECS service |
| ecs_service_name | The name of the ECS service |
| ecs_cluster_arn | The ARN of the ECS cluster |
| ecs_task_definition_arn | The ARN of the task definition |
| security_group_id | The ID of the security group |

## Usage

1. Navigate to this directory
2. Initialize Terraform: `terraform init`
3. Plan the deployment: `terraform plan -var-file=test.tfvars`
4. Apply the configuration: `terraform apply -var-file=test.tfvars`

## Requirements

- Terraform >= 1.0
- AWS provider ~> 5.0
- Access to AWS account with permissions to create ECS resources

## Notes

This example uses the default VPC and subnets. For production use, specify custom VPC configuration.

The example includes KMS encryption by default as per the collection module's configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform.registry.launch.nttdata.com/module_primitive/ecs_cluster/aws | ~> 1.0 |
| <a name="module_ecs_execution_role"></a> [ecs\_execution\_role](#module\_ecs\_execution\_role) | terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws | ~> 0.1 |
| <a name="module_ecs_execution_role_policy_attachment"></a> [ecs\_execution\_role\_policy\_attachment](#module\_ecs\_execution\_role\_policy\_attachment) | terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws | ~> 0.1 |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws | ~> 0.1 |
| <a name="module_ecs_task_definition"></a> [ecs\_task\_definition](#module\_ecs\_task\_definition) | terraform.registry.launch.nttdata.com/module_primitive/ecs_task/aws | ~> 0.1 |
| <a name="module_ecs_service_security_group"></a> [ecs\_service\_security\_group](#module\_ecs\_service\_security\_group) | terraform.registry.launch.nttdata.com/module_primitive/security_group/aws | ~> 0.2 |
| <a name="module_service_name"></a> [service\_name](#module\_service\_name) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.2 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | `"simple-ecs-cluster"` | no |
| <a name="input_execution_role_name"></a> [execution\_role\_name](#input\_execution\_role\_name) | Name of the ECS execution role | `string` | `"simple-ecs-execution-role"` | no |
| <a name="input_task_family"></a> [task\_family](#input\_task\_family) | Family name for the task definition | `string` | `"simple-task"` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `string` | `"simple-ecs-service"` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired number of tasks | `number` | `1` | no |
| <a name="input_task_role_name"></a> [task\_role\_name](#input\_task\_role\_name) | Name of the ECS task role | `string` | `"simple-ecs-task-role"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | <pre>{<br/>  "Environment": "example",<br/>  "Example": "simple"<br/>}</pre> | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | Execute command configuration for the cluster | <pre>object({<br/>    execute_command_configuration = optional(object({<br/>      kms_key_id = optional(string)<br/>      logging    = optional(string, "DEFAULT")<br/>      log_configuration = optional(object({<br/>        cloud_watch_encryption_enabled = optional(bool, false)<br/>        cloud_watch_log_group_name     = optional(string)<br/>        s3_bucket_name                 = optional(string)<br/>        s3_bucket_encryption_enabled   = optional(bool, false)<br/>        s3_key_prefix                  = optional(string)<br/>      }))<br/>    }))<br/>    managed_storage_configuration = optional(object({<br/>      fargate_ephemeral_storage_kms_key_id = optional(string)<br/>      kms_key_id                           = string<br/>    }))<br/>  })</pre> | `{}` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Logical product family for resource naming | `string` | `"demo"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Logical product service for resource naming | `string` | `"ecs"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Class environment for resource naming | `string` | `"dev"` | no |
| <a name="input_cloud_resource_type"></a> [cloud\_resource\_type](#input\_cloud\_resource\_type) | Cloud resource type for resource naming | `string` | `"svc"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Instance environment for resource naming | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Instance resource for resource naming | `number` | `0` | no |
| <a name="input_maximum_length"></a> [maximum\_length](#input\_maximum\_length) | Maximum length for resource naming | `number` | `60` | no |
| <a name="input_separator"></a> [separator](#input\_separator) | Separator for resource naming | `string` | `"-"` | no |
| <a name="input_use_azure_region_abbr"></a> [use\_azure\_region\_abbr](#input\_use\_azure\_region\_abbr) | Whether to use Azure region abbreviation | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_service_id"></a> [ecs\_service\_id](#output\_ecs\_service\_id) | The ID of the ECS service |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | The name of the ECS service |
| <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn) | The ARN of the ECS cluster |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | The ARN of the task definition |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
<!-- END_TF_DOCS -->

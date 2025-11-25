# complete

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform.registry.launch.nttdata.com/module_primitive/ecs_cluster/aws | ~> 1.0 |
| <a name="module_ecs_execution_role"></a> [ecs\_execution\_role](#module\_ecs\_execution\_role) | terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws | ~> 0.1 |
| <a name="module_ecs_execution_role_policy_attachment"></a> [ecs\_execution\_role\_policy\_attachment](#module\_ecs\_execution\_role\_policy\_attachment) | terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws | ~> 0.1 |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws | ~> 0.1 |
| <a name="module_ecs_task_definition"></a> [ecs\_task\_definition](#module\_ecs\_task\_definition) | terraform.registry.launch.nttdata.com/module_primitive/ecs_task/aws | ~> 0.1 |
| <a name="module_ecs_service_security_group"></a> [ecs\_service\_security\_group](#module\_ecs\_service\_security\_group) | terraform.registry.launch.nttdata.com/module_primitive/security_group/aws | ~> 0.2 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"dev"` | no |
| <a name="input_cluster_name_prefix"></a> [cluster\_name\_prefix](#input\_cluster\_name\_prefix) | Prefix for ECS cluster name | `string` | `"example-cluster"` | no |
| <a name="input_task_family_prefix"></a> [task\_family\_prefix](#input\_task\_family\_prefix) | Prefix for task family name | `string` | n/a | yes |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | Compatibility requirements for the task definition | `list(string)` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Network mode for the task | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the task | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the task | `string` | n/a | yes |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Ephemeral storage size in GiB | `number` | n/a | yes |
| <a name="input_operating_system_family"></a> [operating\_system\_family](#input\_operating\_system\_family) | Operating system family | `string` | n/a | yes |
| <a name="input_cpu_architecture"></a> [cpu\_architecture](#input\_cpu\_architecture) | CPU architecture | `string` | n/a | yes |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions for the task | <pre>list(object({<br/>    name      = string<br/>    image     = string<br/>    cpu       = number<br/>    memory    = number<br/>    essential = bool<br/>    environment = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>    portMappings = optional(list(object({<br/>      containerPort = number<br/>      protocol      = string<br/>      name          = optional(string)<br/>    })), [])<br/>    logConfiguration = optional(object({<br/>      logDriver = string<br/>      options   = map(string)<br/>    }))<br/>    healthCheck = optional(object({<br/>      command     = list(string)<br/>      interval    = number<br/>      timeout     = number<br/>      retries     = number<br/>      startPeriod = number<br/>    }))<br/>    command = optional(list(string), [])<br/>    dependsOn = optional(list(object({<br/>      containerName = string<br/>      condition     = string<br/>    })), [])<br/>  }))</pre> | n/a | yes |
| <a name="input_task_tags"></a> [task\_tags](#input\_task\_tags) | Tags for the task definition | `map(string)` | n/a | yes |
| <a name="input_execution_role_name_prefix"></a> [execution\_role\_name\_prefix](#input\_execution\_role\_name\_prefix) | Prefix for ECS execution role name | `string` | n/a | yes |
| <a name="input_task_role_name_prefix"></a> [task\_role\_name\_prefix](#input\_task\_role\_name\_prefix) | Prefix for ECS task role name | `string` | n/a | yes |
| <a name="input_task_policy_name_prefix"></a> [task\_policy\_name\_prefix](#input\_task\_policy\_name\_prefix) | Prefix for task role policy name | `string` | n/a | yes |
| <a name="input_example_name"></a> [example\_name](#input\_example\_name) | Example name for tagging | `string` | n/a | yes |
| <a name="input_service_name_prefix"></a> [service\_name\_prefix](#input\_service\_name\_prefix) | Prefix for ECS service name | `string` | `"example-service"` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired number of tasks for the service | `number` | `1` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type for the service | `string` | `"FARGATE"` | no |
| <a name="input_service_tags"></a> [service\_tags](#input\_service\_tags) | Tags for the ECS service | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the ECS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the ECS cluster |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ARN of the task definition |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | Family of the task definition |
| <a name="output_task_definition_revision"></a> [task\_definition\_revision](#output\_task\_definition\_revision) | Revision of the task definition |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ID of the ECS service |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the ECS service |
| <a name="output_service_desired_count"></a> [service\_desired\_count](#output\_service\_desired\_count) | Desired count of the ECS service |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | ARN of the ECS task execution role |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | ARN of the ECS task role |
| <a name="output_execution_role_name"></a> [execution\_role\_name](#output\_execution\_role\_name) | Name of the ECS task execution role |
| <a name="output_task_role_name"></a> [task\_role\_name](#output\_task\_role\_name) | Name of the ECS task role |
| <a name="output_service_tags"></a> [service\_tags](#output\_service\_tags) | Tags assigned to the ECS service |
<!-- END_TF_DOCS -->

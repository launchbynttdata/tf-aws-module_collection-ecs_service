# tf-aws-module_primitive-ecs_service

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | terraform.registry.launch.nttdata.com/module_primitive/ecs_service/aws | ~> 0.1 |
| <a name="module_ecs_encryption_key"></a> [ecs\_encryption\_key](#module\_ecs\_encryption\_key) | terraform.registry.launch.nttdata.com/module_primitive/kms_key/aws | ~> 0.6 |
| <a name="module_kms_alias"></a> [kms\_alias](#module\_kms\_alias) | terraform.registry.launch.nttdata.com/module_primitive/kms_alias/aws | ~> 0.1 |
| <a name="module_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#module\_cloudwatch\_log\_group) | terraform.registry.launch.nttdata.com/module_primitive/cloudwatch_log_group/aws | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group) | data source |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name for the ECS service | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region for the provider | `string` | `"us-west-2"` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | ARN of the ECS cluster where this service will be placed | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster where this service will be placed (used if cluster ARN is not provided) | `string` | `null` | no |
| <a name="input_task_definition"></a> [task\_definition](#input\_task\_definition) | The family and revision (family:revision) or full ARN of the task definition to run in your service | `string` | `null` | no |
| <a name="input_task_definition_family"></a> [task\_definition\_family](#input\_task\_definition\_family) | The family name of the task definition to look up if task\_definition is not provided | `string` | `null` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | The number of instances of the task definition to place and keep running | `number` | `1` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | The launch type on which to run your service. Valid values: EC2, FARGATE, EXTERNAL | `string` | `"FARGATE"` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | The platform version on which to run your service. Only applicable for launch\_type set to FARGATE | `string` | `"LATEST"` | no |
| <a name="input_iam_role"></a> [iam\_role](#input\_iam\_role) | The ARN of an IAM role that allows your Amazon ECS service to make calls to other AWS services | `string` | `null` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Whether to enable Amazon ECS Exec for the tasks in the service | `bool` | `false` | no |
| <a name="input_enable_ecs_managed_tags"></a> [enable\_ecs\_managed\_tags](#input\_enable\_ecs\_managed\_tags) | Whether to enable Amazon ECS managed tags for the tasks in the service | `bool` | `false` | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | Whether to propagate the tags from the task definition or the service to the tasks | `string` | `"SERVICE"` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Health check grace period in seconds for the service when using load balancers | `number` | `null` | no |
| <a name="input_wait_for_steady_state"></a> [wait\_for\_steady\_state](#input\_wait\_for\_steady\_state) | Whether to wait for the service to reach a steady state before continuing | `bool` | `false` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Whether to force a new task deployment of the service | `bool` | `false` | no |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | Network configuration for the ECS service | <pre>object({<br/>    subnets          = list(string)<br/>    security_groups  = list(string)<br/>    assign_public_ip = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs to use for the ECS service (used when network\_configuration is null) | `list(string)` | `null` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether to assign public IP to the tasks (used when network\_configuration is null) | `bool` | `null` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | ID of the security group to use for the ECS service (used when network\_configuration is null) | `string` | `null` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of the security group to look up if security\_group\_id is not provided (used when network\_configuration is null) | `string` | `null` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Load balancer configuration for the service | <pre>list(object({<br/>    target_group_arn = string<br/>    container_name   = string<br/>    container_port   = number<br/>  }))</pre> | `null` | no |
| <a name="input_load_balancer_target_group_name"></a> [load\_balancer\_target\_group\_name](#input\_load\_balancer\_target\_group\_name) | Name of the target group to look up for load balancer when load\_balancer is not provided | `string` | `null` | no |
| <a name="input_load_balancer_container_name"></a> [load\_balancer\_container\_name](#input\_load\_balancer\_container\_name) | Container name for load balancer when load\_balancer is not provided | `string` | `null` | no |
| <a name="input_load_balancer_container_port"></a> [load\_balancer\_container\_port](#input\_load\_balancer\_container\_port) | Container port for load balancer when load\_balancer is not provided | `number` | `null` | no |
| <a name="input_enable_load_balancer"></a> [enable\_load\_balancer](#input\_enable\_load\_balancer) | Whether to attach a load balancer to the ECS service | `bool` | `false` | no |
| <a name="input_service_connect_configuration"></a> [service\_connect\_configuration](#input\_service\_connect\_configuration) | Service Connect configuration for the service | <pre>object({<br/>    enabled   = bool<br/>    namespace = optional(string)<br/>    log_configuration = optional(object({<br/>      log_driver = string<br/>      options    = map(string)<br/>    }))<br/>    service = optional(object({<br/>      client_alias = object({<br/>        dns_name = string<br/>        port     = number<br/>      })<br/>      discovery_name = string<br/>      port_name      = string<br/>      tls = optional(object({<br/>        issuer_cert_authority = object({<br/>          aws_pca_authority_arn = string<br/>        })<br/>        kms_key  = optional(string)<br/>        role_arn = optional(string)<br/>      }))<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_service_registries"></a> [service\_registries](#input\_service\_registries) | Service discovery registries for the service | <pre>list(object({<br/>    registry_arn   = string<br/>    port           = optional(number)<br/>    container_name = optional(string)<br/>    container_port = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_capacity_provider_strategy"></a> [capacity\_provider\_strategy](#input\_capacity\_provider\_strategy) | Capacity provider strategy to use for the service | <pre>list(object({<br/>    capacity_provider = string<br/>    weight            = number<br/>    base              = optional(number, 0)<br/>  }))</pre> | `[]` | no |
| <a name="input_deployment_configuration"></a> [deployment\_configuration](#input\_deployment\_configuration) | Deployment configuration for the service | <pre>object({<br/>    maximum_percent         = optional(number, 200)<br/>    minimum_healthy_percent = optional(number, 100)<br/>    deployment_circuit_breaker = optional(object({<br/>      enable   = bool<br/>      rollback = bool<br/>    }))<br/>    alarms = optional(object({<br/>      alarm_names = list(string)<br/>      enable      = bool<br/>      rollback    = bool<br/>    }))<br/>    deployment_attempts = optional(number, 2)<br/>  })</pre> | <pre>{<br/>  "maximum_percent": 200,<br/>  "minimum_healthy_percent": 100<br/>}</pre> | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | Placement constraints for the service | <pre>list(object({<br/>    type       = string<br/>    expression = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_ordered_placement_strategy"></a> [ordered\_placement\_strategy](#input\_ordered\_placement\_strategy) | Placement strategy for the service | <pre>list(object({<br/>    type  = string<br/>    field = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_volume_configuration"></a> [volume\_configuration](#input\_volume\_configuration) | Configuration for EBS volumes that are attached to tasks | <pre>object({<br/>    name = string<br/>    managed_ebs_volume = object({<br/>      role_arn         = string<br/>      encrypted        = optional(bool, true)<br/>      file_system_type = optional(string, "ext4")<br/>      iops             = optional(number)<br/>      kms_key_id       = optional(string)<br/>      size_in_gb       = optional(number, 20)<br/>      snapshot_id      = optional(string)<br/>      throughput       = optional(number)<br/>      volume_type      = optional(string, "gp3")<br/>      tag_specifications = optional(list(object({<br/>        resource_type = string<br/>        tags          = map(string)<br/>      })), [])<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the ECS service | `map(string)` | `{}` | no |
| <a name="input_cloudwatch_logs_region"></a> [cloudwatch\_logs\_region](#input\_cloudwatch\_logs\_region) | Region for CloudWatch logs | `string` | `null` | no |
| <a name="input_service_connect_log_group_name"></a> [service\_connect\_log\_group\_name](#input\_service\_connect\_log\_group\_name) | (Optional, Forces new resource) The name of the log group. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |
| <a name="input_service_connect_log_group_skip_destroy"></a> [service\_connect\_log\_group\_skip\_destroy](#input\_service\_connect\_log\_group\_skip\_destroy) | (Optional) Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state. | `bool` | `false` | no |
| <a name="input_service_connect_log_group_retention_days"></a> [service\_connect\_log\_group\_retention\_days](#input\_service\_connect\_log\_group\_retention\_days) | (Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `30` | no |
| <a name="input_service_connect_log_group_tags"></a> [service\_connect\_log\_group\_tags](#input\_service\_connect\_log\_group\_tags) | A map of tags to add to the resources created by the module. | `map(string)` | `{}` | no |
| <a name="input_enable_kms_encryption"></a> [enable\_kms\_encryption](#input\_enable\_kms\_encryption) | Whether to create a KMS key for encryption | `bool` | `true` | no |
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | Description for the KMS key | `string` | `"KMS key for ECS service encryption"` | no |
| <a name="input_kms_key_alias_suffix"></a> [kms\_key\_alias\_suffix](#input\_kms\_key\_alias\_suffix) | Suffix for the KMS key alias name | `string` | `"-ecs-encryption"` | no |
| <a name="input_kms_key_usage"></a> [kms\_key\_usage](#input\_kms\_key\_usage) | Intended use of the key | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_kms_key_spec"></a> [kms\_key\_spec](#input\_kms\_key\_spec) | Specification of the key | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_kms_key_is_enabled"></a> [kms\_key\_is\_enabled](#input\_kms\_key\_is\_enabled) | Whether the key is enabled | `bool` | `true` | no |
| <a name="input_kms_key_enable_key_rotation"></a> [kms\_key\_enable\_key\_rotation](#input\_kms\_key\_enable\_key\_rotation) | Whether to enable key rotation | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the ECS service |
| <a name="output_name"></a> [name](#output\_name) | The name of the ECS service |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | The cluster the ECS service is associated with |
| <a name="output_desired_count"></a> [desired\_count](#output\_desired\_count) | The desired number of tasks for the ECS service |
| <a name="output_task_definition"></a> [task\_definition](#output\_task\_definition) | The task definition ARN used by the ECS service |
| <a name="output_launch_type"></a> [launch\_type](#output\_launch\_type) | The launch type of the ECS service |
| <a name="output_platform_version"></a> [platform\_version](#output\_platform\_version) | The platform version of the ECS service |
| <a name="output_deployment_configuration"></a> [deployment\_configuration](#output\_deployment\_configuration) | The deployment configuration of the ECS service |
| <a name="output_network_configuration"></a> [network\_configuration](#output\_network\_configuration) | The network configuration of the ECS service |
| <a name="output_load_balancer_configuration"></a> [load\_balancer\_configuration](#output\_load\_balancer\_configuration) | The load balancer configuration of the ECS service |
| <a name="output_service_connect_configuration"></a> [service\_connect\_configuration](#output\_service\_connect\_configuration) | The service connect configuration of the ECS service |
| <a name="output_service_registries"></a> [service\_registries](#output\_service\_registries) | The effective service registries configuration of the ECS service (includes Service Connect registry if configured) |
| <a name="output_service_connect_service_arn"></a> [service\_connect\_service\_arn](#output\_service\_connect\_service\_arn) | ARN of the Service Connect service discovered via data source (if lookup is configured) |
| <a name="output_service_connect_service_discovery_name"></a> [service\_connect\_service\_discovery\_name](#output\_service\_connect\_service\_discovery\_name) | Discovery name of the Service Connect service (from configuration) |
| <a name="output_capacity_provider_strategy"></a> [capacity\_provider\_strategy](#output\_capacity\_provider\_strategy) | The capacity provider strategy of the ECS service |
| <a name="output_placement_constraints"></a> [placement\_constraints](#output\_placement\_constraints) | The placement constraints of the ECS service |
| <a name="output_placement_strategy"></a> [placement\_strategy](#output\_placement\_strategy) | The placement strategy of the ECS service |
| <a name="output_volume_configuration"></a> [volume\_configuration](#output\_volume\_configuration) | The volume configuration of the ECS service |
| <a name="output_enable_execute_command"></a> [enable\_execute\_command](#output\_enable\_execute\_command) | Whether ECS Exec is enabled for the service |
| <a name="output_enable_ecs_managed_tags"></a> [enable\_ecs\_managed\_tags](#output\_enable\_ecs\_managed\_tags) | Whether ECS managed tags are enabled for the service |
| <a name="output_propagate_tags"></a> [propagate\_tags](#output\_propagate\_tags) | How tags are propagated to tasks |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the ECS service |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including provider default\_tags |
| <a name="output_service_details"></a> [service\_details](#output\_service\_details) | Comprehensive details about the ECS service for integration purposes |
| <a name="output_service_configuration"></a> [service\_configuration](#output\_service\_configuration) | Summary of the ECS service configuration |
| <a name="output_service_connect_log_group_name"></a> [service\_connect\_log\_group\_name](#output\_service\_connect\_log\_group\_name) | n/a |
| <a name="output_service_connect_log_group_arn"></a> [service\_connect\_log\_group\_arn](#output\_service\_connect\_log\_group\_arn) | n/a |
| <a name="output_ecs_encryption_key_arn"></a> [ecs\_encryption\_key\_arn](#output\_ecs\_encryption\_key\_arn) | ARN of the KMS key created for ECS encryption (if enabled) |
| <a name="output_ecs_encryption_key_id"></a> [ecs\_encryption\_key\_id](#output\_ecs\_encryption\_key\_id) | ID of the KMS key created for ECS encryption (if enabled) |
<!-- END_TF_DOCS -->
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# ============================================
# ECS SERVICE PRIMITIVE OUTPUTS
# ============================================

output "id" {
  description = "The ID of the ECS service"
  value       = module.ecs_service.id
}

output "name" {
  description = "The name of the ECS service"
  value       = module.ecs_service.name
}

output "cluster" {
  description = "The cluster the ECS service is associated with"
  value       = module.ecs_service.cluster
}

output "desired_count" {
  description = "The desired number of tasks for the ECS service"
  value       = module.ecs_service.desired_count
}

output "task_definition" {
  description = "The task definition ARN used by the ECS service"
  value       = module.ecs_service.task_definition
}

output "launch_type" {
  description = "The launch type of the ECS service"
  value       = module.ecs_service.launch_type
}

output "platform_version" {
  description = "The platform version of the ECS service"
  value       = module.ecs_service.platform_version
}

output "deployment_configuration" {
  description = "The deployment configuration of the ECS service"
  value       = module.ecs_service.deployment_configuration
}

output "network_configuration" {
  description = "The network configuration of the ECS service"
  value       = module.ecs_service.network_configuration
}

output "load_balancer_configuration" {
  description = "The load balancer configuration of the ECS service"
  value       = module.ecs_service.load_balancer_configuration
}

output "service_connect_configuration" {
  description = "The service connect configuration of the ECS service"
  value       = module.ecs_service.service_connect_configuration
}

output "service_registries" {
  description = "The effective service registries configuration of the ECS service (includes Service Connect registry if configured)"
  value       = module.ecs_service.service_registries
}

output "service_connect_service_arn" {
  description = "ARN of the Service Connect service discovered via data source (if lookup is configured)"
  value       = module.ecs_service.service_connect_service_arn
}

output "service_connect_service_discovery_name" {
  description = "Discovery name of the Service Connect service (from configuration)"
  value       = module.ecs_service.service_connect_service_discovery_name
}

output "capacity_provider_strategy" {
  description = "The capacity provider strategy of the ECS service"
  value       = module.ecs_service.capacity_provider_strategy
}

output "placement_constraints" {
  description = "The placement constraints of the ECS service"
  value       = module.ecs_service.placement_constraints
}

output "placement_strategy" {
  description = "The placement strategy of the ECS service"
  value       = module.ecs_service.placement_strategy
}

output "volume_configuration" {
  description = "The volume configuration of the ECS service"
  value       = module.ecs_service.volume_configuration
}

output "enable_execute_command" {
  description = "Whether ECS Exec is enabled for the service"
  value       = module.ecs_service.enable_execute_command
}

output "enable_ecs_managed_tags" {
  description = "Whether ECS managed tags are enabled for the service"
  value       = module.ecs_service.enable_ecs_managed_tags
}

output "propagate_tags" {
  description = "How tags are propagated to tasks"
  value       = module.ecs_service.propagate_tags
}

output "tags" {
  description = "A map of tags assigned to the ECS service"
  value       = module.ecs_service.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including provider default_tags"
  value       = module.ecs_service.tags_all
}

output "service_details" {
  description = "Comprehensive details about the ECS service for integration purposes"
  value       = module.ecs_service.service_details
}

output "service_configuration" {
  description = "Summary of the ECS service configuration"
  value       = module.ecs_service.service_configuration
}

output "service_connect_log_group_name" {
  value = module.cloudwatch_log_group.log_group_name
}

output "service_connect_log_group_arn" {
  value = module.cloudwatch_log_group.log_group_arn
}

output "ecs_encryption_key_arn" {
  description = "ARN of the KMS key created for ECS encryption (if enabled)"
  value       = var.enable_kms_encryption ? try(module.ecs_encryption_key[0].key_arn, null) : null
}

output "ecs_encryption_key_id" {
  description = "ID of the KMS key created for ECS encryption (if enabled)"
  value       = var.enable_kms_encryption ? module.ecs_encryption_key[0].key_id : null
}

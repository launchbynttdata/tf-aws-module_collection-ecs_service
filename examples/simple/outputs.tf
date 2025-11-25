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

output "ecs_service_id" {
  description = "The ID of the ECS service"
  value       = module.ecs_service.id
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = module.ecs_service.name
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs_cluster.arn
}

output "ecs_task_definition_arn" {
  description = "The ARN of the task definition"
  value       = module.ecs_task_definition.arn
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.ecs_service_security_group.id
}

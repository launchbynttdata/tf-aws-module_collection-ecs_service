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
# LOCAL VALUES AND COMPUTED EXPRESSIONS
# ============================================

locals {
  security_group_id = var.network_configuration != null ? null : (var.security_group_id != null ? var.security_group_id : data.aws_security_group.this[0].id)

  network_configuration = var.network_configuration != null ? var.network_configuration : {
    subnets          = var.subnets
    security_groups  = [local.security_group_id]
    assign_public_ip = var.assign_public_ip
  }

  cluster = var.cluster != null ? var.cluster : data.aws_ecs_cluster.this[0].arn

  task_definition = var.task_definition != null ? var.task_definition : data.aws_ecs_task_definition.this[0].arn

  service_connect_log_group_name = var.service_connect_log_group_name != null ? var.service_connect_log_group_name : var.name

  service_connect_log_group_kms_key_id = var.enable_kms_encryption ? try(module.ecs_encryption_key[0].key_arn, null) : null

  service_connect_configuration = var.service_connect_configuration != null ? (
    var.service_connect_configuration.log_configuration != null ?
    var.service_connect_configuration :
    merge(var.service_connect_configuration, {
      log_configuration = {
        log_driver = "awslogs"
        options = {
          "awslogs-group"         = module.cloudwatch_log_group.log_group_name
          "awslogs-region"        = var.cloudwatch_logs_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    })
  ) : null

  # Load Balancer Configuration (conditional)
  load_balancer = var.enable_load_balancer ? (var.load_balancer != null ? var.load_balancer[0] : {
    target_group_arn = data.aws_lb_target_group.main[0].arn
    container_name   = var.load_balancer_container_name
    container_port   = var.load_balancer_container_port
  }) : null

  tags = merge(
    {
      "ManagedBy" = "Terraform"
    },
    var.tags,
  )
}

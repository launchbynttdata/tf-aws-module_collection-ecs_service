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
# AWS PROVIDER CONFIGURATION
# ============================================

provider "aws" {
  region = var.region
}

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
# ECS SERVICE PRIMITIVE MODULE
# ============================================
# This module creates an ECS service with comprehensive configuration

module "ecs_service" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/ecs_service/aws"
  version = "~> 0.1"

  name                              = var.name
  cluster                           = local.cluster
  task_definition                   = local.task_definition
  desired_count                     = var.desired_count
  launch_type                       = var.launch_type
  platform_version                  = var.platform_version
  iam_role                          = var.iam_role
  enable_execute_command            = var.enable_execute_command
  enable_ecs_managed_tags           = var.enable_ecs_managed_tags
  propagate_tags                    = var.propagate_tags
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  wait_for_steady_state             = var.wait_for_steady_state
  force_new_deployment              = var.force_new_deployment
  network_configuration             = local.network_configuration
  load_balancer                     = local.load_balancer != null ? [local.load_balancer] : []
  service_connect_configuration     = local.service_connect_configuration
  service_registries                = var.service_registries
  capacity_provider_strategy        = var.capacity_provider_strategy
  deployment_configuration          = var.deployment_configuration
  placement_constraints             = var.placement_constraints
  ordered_placement_strategy        = var.ordered_placement_strategy
  volume_configuration              = var.volume_configuration
  tags                              = local.tags
}

module "ecs_encryption_key" {
  source = "terraform.registry.launch.nttdata.com/module_primitive/kms_key/aws"

  version = "~> 0.6"

  count = var.enable_kms_encryption ? 1 : 0

  description         = var.kms_key_description
  key_usage           = var.kms_key_usage
  is_enabled          = var.kms_key_is_enabled
  enable_key_rotation = var.kms_key_enable_key_rotation
  tags                = local.tags
}

module "kms_alias" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/kms_alias/aws"
  version = "~> 0.1"

  count = var.enable_kms_encryption ? 1 : 0

  name          = "alias/${var.name}${var.kms_key_alias_suffix}"
  target_key_id = module.ecs_encryption_key[0].arn
}

module "cloudwatch_log_group" {
  source = "terraform.registry.launch.nttdata.com/module_primitive/cloudwatch_log_group/aws"

  version = "~> 1.0"

  name           = local.service_connect_log_group_name
  skip_destroy   = var.service_connect_log_group_skip_destroy
  retention_days = var.service_connect_log_group_retention_days
  kms_key_id     = local.service_connect_log_group_kms_key_id
  tags           = var.service_connect_log_group_tags
}

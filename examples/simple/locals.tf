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

locals {
  common_name_params = {
    logical_product_family  = var.logical_product_family
    logical_product_service = var.logical_product_service
    region                  = var.region
    class_env               = var.class_env
    cloud_resource_type     = var.cloud_resource_type
    instance_env            = var.instance_env
    instance_resource       = var.instance_resource
    maximum_length          = var.maximum_length
    separator               = var.separator
  }

  resource_specific = {
    cluster = {
      cloud_resource_type = "cluster"
    }
    service = {
      cloud_resource_type = "service"
    }
    execution_role = {
      cloud_resource_type = "executionrole"
    }
    task_role = {
      cloud_resource_type = "taskrole"
    }
    task_definition = {
      cloud_resource_type = "taskdefinition"
    }
    security_group = {
      cloud_resource_type = "sg"
    }
  }

  name_configs = { for k, v in local.resource_specific : k => merge(local.common_name_params, v) }

  task_family_name = module.resource_names["task_definition"].minimal_random_suffix

  cluster_name        = module.resource_names["cluster"].minimal_random_suffix
  execution_role_name = module.resource_names["execution_role"].minimal_random_suffix
  task_role_name      = module.resource_names["task_role"].minimal_random_suffix
  security_group_name = module.resource_names["security_group"].minimal_random_suffix
  service_name        = module.resource_names["service"].minimal_random_suffix

  container_definitions = [
    {
      name  = "app"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${local.task_family_name}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]
}

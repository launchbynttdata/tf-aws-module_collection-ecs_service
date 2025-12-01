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

# ECS Cluster
module "ecs_cluster" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/ecs_cluster/aws"
  version = "~> 1.0"

  name = local.cluster_name

  configuration = var.configuration

  tags = var.tags
}

# ECS Task Execution Role
module "ecs_execution_role" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws"
  version = "~> 0.1"

  name = local.execution_role_name

  assume_role_policy = [{
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals = [{
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }]
  }]

  tags = var.tags
}

# Attach AWS managed policy for ECS task execution
module "ecs_execution_role_policy_attachment" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws"
  version = "~> 0.1"

  role_name  = module.ecs_execution_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  depends_on = [module.ecs_execution_role]
}

# ECS Task Role (for containers to access AWS services)
module "ecs_task_role" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws"
  version = "~> 0.1"

  name = local.task_role_name

  assume_role_policy = [{
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals = [{
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }]
  }]

  tags = var.tags
}

# Resource name for the service
module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.2"

  for_each = local.name_configs

  logical_product_family  = each.value.logical_product_family
  logical_product_service = each.value.logical_product_service
  region                  = each.value.region
  class_env               = each.value.class_env
  cloud_resource_type     = each.value.cloud_resource_type
  instance_env            = each.value.instance_env
  instance_resource       = each.value.instance_resource
  maximum_length          = each.value.maximum_length
  separator               = each.value.separator
}

# ECS Task Definition
module "ecs_task_definition" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/ecs_task/aws"
  version = "~> 0.1"

  family                   = local.task_family_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = module.ecs_execution_role.role_arn
  task_role_arn            = module.ecs_task_role.role_arn

  container_definitions = local.container_definitions

  tags = var.tags
}

# Security group for the service
module "ecs_service_security_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/security_group/aws"
  version = "~> 0.2"

  name   = local.security_group_name
  vpc_id = data.aws_vpc.default.id

  tags = var.tags
}

module "ecs_service" {
  source = "../.."

  name            = local.service_name
  cluster         = module.ecs_cluster.arn
  task_definition = module.ecs_task_definition.arn

  desired_count = var.desired_count
  launch_type   = "FARGATE"

  network_configuration = {
    subnets          = data.aws_subnets.default.ids
    security_groups  = []
    assign_public_ip = true
  }

  tags = var.tags
}

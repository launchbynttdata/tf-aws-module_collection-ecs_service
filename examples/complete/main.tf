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

  name = "${var.cluster_name_prefix}-${var.environment}"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Example     = var.example_name
  }
}

# ECS Task Execution Role
module "ecs_execution_role" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws"
  version = "~> 0.1"

  name = "${var.execution_role_name_prefix}-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Example     = var.example_name
  }
}

# Attach AWS managed policy for ECS task execution
module "ecs_execution_role_policy_attachment" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws"
  version = "~> 0.1"

  role       = module.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  depends_on = [module.ecs_execution_role]
}

# ECS Task Role (for containers to access AWS services)
module "ecs_task_role" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws"
  version = "~> 0.1"

  name = "${var.task_role_name_prefix}-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Example     = var.example_name
  }
}



# ECS Task Definition
module "ecs_task_definition" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/ecs_task/aws"
  version = "~> 0.1"

  family                   = "${var.task_family_prefix}-${var.environment}"
  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = module.ecs_execution_role.arn
  task_role_arn            = module.ecs_task_role.arn

  # Ephemeral storage
  ephemeral_storage {
    size_in_gib = var.ephemeral_storage_size
  }

  # Runtime platform
  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  # Container definitions
  container_definitions = jsonencode(var.container_definitions)

  tags = var.task_tags
}

# VPC and subnets for network configuration
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group for the service
module "ecs_service_security_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/security_group/aws"
  version = "~> 0.2"

  name   = "${var.service_name_prefix}-${var.environment}"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Example     = var.example_name
  }
}

# ECS Service
module "ecs_service" {
  source = "../.."

  name            = "${var.service_name_prefix}-${var.environment}"
  cluster         = module.ecs_cluster.arn
  task_definition = module.ecs_task_definition.arn

  desired_count = var.desired_count
  launch_type   = var.launch_type

  network_configuration = {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [module.ecs_service_security_group.id]
    assign_public_ip = false
  }

  tags = var.service_tags
}

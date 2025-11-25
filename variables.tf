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
# ECS SERVICE PRIMITIVE VARIABLES
# ============================================

variable "name" {
  description = "Name for the ECS service"
  type        = string
}

variable "region" {
  description = "AWS region for the provider"
  type        = string
  default     = "us-east-2"
}

variable "cluster" {
  description = "ARN of the ECS cluster where this service will be placed"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the ECS cluster where this service will be placed (used if cluster ARN is not provided)"
  type        = string
  default     = null
}

variable "task_definition" {
  description = "The family and revision (family:revision) or full ARN of the task definition to run in your service"
  type        = string
  default     = null
}

variable "task_definition_family" {
  description = "The family name of the task definition to look up if task_definition is not provided"
  type        = string
  default     = null
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "launch_type" {
  description = "The launch type on which to run your service. Valid values: EC2, FARGATE, EXTERNAL"
  type        = string
  default     = "FARGATE"
}

variable "platform_version" {
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE"
  type        = string
  default     = "LATEST"
}

variable "iam_role" {
  description = "The ARN of an IAM role that allows your Amazon ECS service to make calls to other AWS services"
  type        = string
  default     = null
}

variable "enable_execute_command" {
  description = "Whether to enable Amazon ECS Exec for the tasks in the service"
  type        = bool
  default     = false
}

variable "enable_ecs_managed_tags" {
  description = "Whether to enable Amazon ECS managed tags for the tasks in the service"
  type        = bool
  default     = false
}

variable "propagate_tags" {
  description = "Whether to propagate the tags from the task definition or the service to the tasks"
  type        = string
  default     = "SERVICE"
}

variable "health_check_grace_period_seconds" {
  description = "Health check grace period in seconds for the service when using load balancers"
  type        = number
  default     = null
}

variable "wait_for_steady_state" {
  description = "Whether to wait for the service to reach a steady state before continuing"
  type        = bool
  default     = false
}

variable "force_new_deployment" {
  description = "Whether to force a new task deployment of the service"
  type        = bool
  default     = false
}

variable "network_configuration" {
  description = "Network configuration for the ECS service"
  type = object({
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = optional(bool, false)
  })
  default = null
}

variable "subnets" {
  description = "List of subnet IDs to use for the ECS service (used when network_configuration is null)"
  type        = list(string)
  default     = null
}

variable "assign_public_ip" {
  description = "Whether to assign public IP to the tasks (used when network_configuration is null)"
  type        = bool
  default     = null
}

variable "security_group_id" {
  description = "ID of the security group to use for the ECS service (used when network_configuration is null)"
  type        = string
  default     = null
}

variable "security_group_name" {
  description = "Name of the security group to look up if security_group_id is not provided (used when network_configuration is null)"
  type        = string
  default     = null
}

variable "load_balancer" {
  description = "Load balancer configuration for the service"
  type = list(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  default = null
}

variable "load_balancer_target_group_name" {
  description = "Name of the target group to look up for load balancer when load_balancer is not provided"
  type        = string
  default     = null
}

variable "load_balancer_container_name" {
  description = "Container name for load balancer when load_balancer is not provided"
  type        = string
  default     = null
}

variable "load_balancer_container_port" {
  description = "Container port for load balancer when load_balancer is not provided"
  type        = number
  default     = null
}

variable "enable_load_balancer" {
  description = "Whether to attach a load balancer to the ECS service"
  type        = bool
  default     = false
}

variable "service_connect_configuration" {
  description = "Service Connect configuration for the service"
  type = object({
    enabled   = bool
    namespace = optional(string)
    log_configuration = optional(object({
      log_driver = string
      options    = map(string)
    }))
    service = optional(object({
      client_alias = object({
        dns_name = string
        port     = number
      })
      discovery_name = string
      port_name      = string
      tls = optional(object({
        issuer_cert_authority = object({
          aws_pca_authority_arn = string
        })
        kms_key  = optional(string)
        role_arn = optional(string)
      }))
    }))
  })
  default = null
}

variable "service_registries" {
  description = "Service discovery registries for the service"
  type = list(object({
    registry_arn   = string
    port           = optional(number)
    container_name = optional(string)
    container_port = optional(number)
  }))
  default = []
}

variable "capacity_provider_strategy" {
  description = "Capacity provider strategy to use for the service"
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = optional(number, 0)
  }))
  default = []
}

variable "deployment_configuration" {
  description = "Deployment configuration for the service"
  type = object({
    maximum_percent         = optional(number, 200)
    minimum_healthy_percent = optional(number, 100)
    deployment_circuit_breaker = optional(object({
      enable   = bool
      rollback = bool
    }))
    alarms = optional(object({
      alarm_names = list(string)
      enable      = bool
      rollback    = bool
    }))
    deployment_attempts = optional(number, 2)
  })
  default = {
    maximum_percent         = 200
    minimum_healthy_percent = 100
  }
}

variable "placement_constraints" {
  description = "Placement constraints for the service"
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []
}

variable "ordered_placement_strategy" {
  description = "Placement strategy for the service"
  type = list(object({
    type  = string
    field = optional(string)
  }))
  default = []
}

variable "volume_configuration" {
  description = "Configuration for EBS volumes that are attached to tasks"
  type = object({
    name = string
    managed_ebs_volume = object({
      role_arn         = string
      encrypted        = optional(bool, true)
      file_system_type = optional(string, "ext4")
      iops             = optional(number)
      kms_key_id       = optional(string)
      size_in_gb       = optional(number, 20)
      snapshot_id      = optional(string)
      throughput       = optional(number)
      volume_type      = optional(string, "gp3")
      tag_specifications = optional(list(object({
        resource_type = string
        tags          = map(string)
      })), [])
    })
  })
  default = null
}

variable "tags" {
  description = "A map of tags to add to the ECS service"
  type        = map(string)
  default     = {}
}

variable "cloudwatch_logs_region" {
  description = "Region for CloudWatch logs"
  type        = string
  default     = null
}

variable "service_connect_log_group_name" {
  description = "(Optional, Forces new resource) The name of the log group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "service_connect_log_group_skip_destroy" {
  description = "(Optional) Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state."
  type        = bool
  default     = false
}

variable "service_connect_log_group_retention_days" {
  type        = number
  default     = 30
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
}

variable "service_connect_log_group_tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to the resources created by the module."
}

# KMS Key Configuration
variable "enable_kms_encryption" {
  description = "Whether to create a KMS key for encryption"
  type        = bool
  default     = true
}

variable "kms_key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "KMS key for ECS service encryption"
}

variable "kms_key_alias_suffix" {
  description = "Suffix for the KMS key alias name"
  type        = string
  default     = "-ecs-encryption"
}

variable "kms_key_usage" {
  description = "Intended use of the key"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "kms_key_spec" {
  description = "Specification of the key"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "kms_key_is_enabled" {
  description = "Whether the key is enabled"
  type        = bool
  default     = true
}

variable "kms_key_enable_key_rotation" {
  description = "Whether to enable key rotation"
  type        = bool
  default     = true
}

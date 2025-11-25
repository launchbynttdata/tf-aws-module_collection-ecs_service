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

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "simple-ecs-cluster"
}

variable "execution_role_name" {
  description = "Name of the ECS execution role"
  type        = string
  default     = "simple-ecs-execution-role"
}

variable "task_family" {
  description = "Family name for the task definition"
  type        = string
  default     = "simple-task"
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "simple-ecs-service"
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "task_role_name" {
  description = "Name of the ECS task role"
  type        = string
  default     = "simple-ecs-task-role"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "example"
    Example     = "simple"
  }
}

variable "configuration" {
  description = "Execute command configuration for the cluster"
  type = object({
    execute_command_configuration = optional(object({
      kms_key_id = optional(string)
      logging    = optional(string, "DEFAULT")
      log_configuration = optional(object({
        cloud_watch_encryption_enabled = optional(bool, false)
        cloud_watch_log_group_name     = optional(string)
        s3_bucket_name                 = optional(string)
        s3_bucket_encryption_enabled   = optional(bool, false)
        s3_key_prefix                  = optional(string)
      }))
    }))
    managed_storage_configuration = optional(object({
      fargate_ephemeral_storage_kms_key_id = optional(string)
      kms_key_id                           = string
    }))
  })
  default = {}
}

variable "logical_product_family" {
  description = "Logical product family for resource naming"
  type        = string
  default     = "demo"
}

variable "logical_product_service" {
  description = "Logical product service for resource naming"
  type        = string
  default     = "ecs"
}

variable "class_env" {
  description = "Class environment for resource naming"
  type        = string
  default     = "dev"
}

variable "cloud_resource_type" {
  description = "Cloud resource type for resource naming"
  type        = string
  default     = "svc"
}

variable "instance_env" {
  description = "Instance environment for resource naming"
  type        = number
  default     = 0
}

variable "instance_resource" {
  description = "Instance resource for resource naming"
  type        = number
  default     = 0
}

variable "maximum_length" {
  description = "Maximum length for resource naming"
  type        = number
  default     = 60
}

variable "separator" {
  description = "Separator for resource naming"
  type        = string
  default     = "-"
}

variable "use_azure_region_abbr" {
  description = "Whether to use Azure region abbreviation"
  type        = bool
  default     = false
}

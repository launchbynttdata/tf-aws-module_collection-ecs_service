# ECS Service Module Examples

This directory contains comprehensive examples demonstrating the capabilities of the ECS service module. Each example showcases different use cases and configuration patterns.

## Available Examples

### 1. [Simple](./simple/)
**Basic ECS service setup**
- Minimal FARGATE service configuration
- Essential prerequisites (cluster, task definition, roles)
- Default VPC usage
- Basic nginx container example

### 2. [Complete](./complete/)
**Comprehensive ECS service with all features**
- FARGATE launch type configuration
- Task definition with container definitions
- ECS cluster setup
- IAM execution role and task role setup
- Security group configuration
- Network configuration with awsvpc mode
- CloudWatch logging integration
- Sample IAM policies for containers

## Features Demonstrated

### Core Module Features
- ✅ **Service naming**: ECS service name and configuration
- ✅ **Cluster integration**: Connection to ECS cluster
- ✅ **Task definition**: Reference to task definition
- ✅ **Launch types**: FARGATE and EC2 compatibility
- ✅ **Desired count**: Number of tasks to run
- ✅ **Network configuration**: VPC, subnets, and security groups
- ✅ **Load balancing**: Integration with load balancers (future)
- ✅ **Tags**: Comprehensive tagging for resource organization

### Advanced Features
- ✅ **Task definition integration**: Full task definition support
- ✅ **Security groups**: Service-level security configuration
- ✅ **Public IP assignment**: Control over public IP allocation
- ✅ **Service discovery**: Integration with service discovery (future)
- ✅ **Deployment configuration**: Rolling updates and circuit breakers
- ✅ **Health checks**: Container health monitoring
- ✅ **Logging**: CloudWatch logs integration

### IAM Integration
- ✅ **Task execution role**: Pull images and CloudWatch logs
- ✅ **Task role**: Container application permissions
- ✅ **Inline policies**: Custom permissions for containers
- ✅ **AWS managed policies**: Standard role policies

## Running the Examples

Each example includes:
- `main.tf`: Module usage and supporting resources
- `variables.tf`: Configurable parameters with defaults
- `outputs.tf`: Useful outputs for integration
- `versions.tf`: Provider requirements
- `terraform.tfvars`: Example variable values

### Quick Start

```bash
# Navigate to the example
cd examples/complete

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan

# Apply configuration (requires AWS credentials)
terraform apply
```

### Validating Examples

```bash
# Validate the complete example
cd examples/complete
terraform init -backend=false
terraform validate
```

## Module Capability Coverage

The complete example provides comprehensive coverage:

- **Core ECS service** functionality
- **FARGATE** launch type configuration
- **Task definition** integration
- **ECS cluster** setup
- **IAM role** setup and permissions
- **Security group** configuration
- **Network configuration** with awsvpc mode
- **Container definitions** with multiple configurations
- **Logging and monitoring** integration
- **Best practices** for production deployments

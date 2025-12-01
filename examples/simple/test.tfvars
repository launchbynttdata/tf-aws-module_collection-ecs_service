# Test variables for the simple ECS service example

region = "us-east-2"

desired_count = 1

tags = {
  Environment = "test"
  Example     = "simple"
}

configuration = {}

logical_product_family = "demo"

logical_product_service = "ecs"

class_env = "terratest"

cloud_resource_type = "svc"

instance_env = 0

instance_resource = 0

maximum_length = 60

separator = "-"

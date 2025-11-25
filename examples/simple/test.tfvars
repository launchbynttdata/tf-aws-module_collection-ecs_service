# Test variables for the simple ECS service example

region = "us-east-2"

cluster_name = "simple-ecs-cluster"

execution_role_name = "simple-ecs-execution-role"

task_family = "simple-task"

service_name = "simple-ecs-service"

task_role_name = "simple-ecs-task-role"

desired_count = 1

tags = {
  Environment = "test"
  Example     = "simple"
}

configuration = {}

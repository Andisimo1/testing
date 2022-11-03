#Elastic Container Repository
resource "aws_ecr_repository" "ecr" {
  name = "ecr"
}

#ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "Cluster"
}

#ECS Service
resource "aws_ecs_service" "ecs" {
  name                 = "ecs-service"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.definition.id
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true
  network_configuration {
    subnets          = var.private_subnet
    assign_public_ip = true
  }
  depends_on = [ 
    var.alb_listener, var.iam_role
  ]
}

#ECS Task
resource "aws_ecs_task_definition" "definition" {
  family                   = "task_definition_name"
  execution_role_arn       = aws_iam_role.role_test.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name = "first"
      image = "366915744137.dkr.ecr.eu-central-1.amazonaws.com/andisimo1/firstdemo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])
}

#IAM Role
resource "aws_iam_role" "role_test" {
  name = "role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "IAM Role for ECS"
  }
}

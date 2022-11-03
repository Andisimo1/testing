output "ecr" {
  value = aws_ecr_repository.ecr.id
}

output "ecs_cluster" {
  value = aws_ecs_cluster.main.id
}

output "ecs" {
  value = aws_ecs_service.ecs.id
}

output "task_definition" {
  value = aws_ecs_task_definition.definition.id
}

output "iam_role" {
  value = aws_iam_role.role_test.id
}

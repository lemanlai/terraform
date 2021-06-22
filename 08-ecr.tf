resource "aws_ecr_repository" "leman-test-ecs_kong" {
    name = "leman-test-ecs-kong-${local.time_suffix}"
}
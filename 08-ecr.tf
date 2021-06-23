resource "aws_ecr_repository" "leman_test_ecs_kong" {
    name = "leman-test-ecr-kong-${local.time_suffix_short}"
    
    lifecycle {
        prevent_destroy = true
        ignore_changes =[name]
    }
    tags = {
        Name = "leman-test-ecr-kong-${local.time_suffix}"
        Owner = "leman-test-${local.time_suffix}"
    }
}

resource "aws_ecr_lifecycle_policy" "leman_test_ecs_kong" {
    repository = aws_ecr_repository.leman_test_ecs_kong.name
    policy = file("./policy/ecr.json")
}



output "ecr_url" {
    value = aws_ecr_repository.leman_test_ecs_kong.repository_url
}
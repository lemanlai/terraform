create ecs kong test

# 1. initial env
- create s3 bucket if not exsit
  ```bash
  ./initial/s3-setup.sh staging us-east-1
  ```
- terraform init
  ```bash
  terraform init -backend-config=staging-leman-test.backend
  ```

# 2.  ecr
- create ecr
  ```bash
  terraform plan -var-file=staging-leman-test.tfvars -target=aws_ecr_lifecycle_policy.leman_test_ecs_kong \
  -target=aws_ecr_repository.leman_test_ecs_kong

  terraform apply -var-file=staging-leman-test.tfvars -target=aws_ecr_lifecycle_policy.leman_test_ecs_kong \
  -target=aws_ecr_repository.leman_test_ecs_kong

  ➜  terraform git:(main) ✗ terraform apply -var-file=staging-leman-test.tfvars -target=aws_ecr_lifecycle_policy.leman_test_ecs_kong \
  -target=aws_ecr_repository.leman_test_ecs_kong
Acquiring state lock. This may take a few moments...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_ecr_lifecycle_policy.leman_test_ecs_kong will be created
  + resource "aws_ecr_lifecycle_policy" "leman_test_ecs_kong" {
      + id          = (known after apply)
      + policy      = jsonencode(
            {
              + rules = [
                  + {
                      + action       = {
                          + type = "expire"
                        }
                      + description  = "Keep 100 images"
                      + rulePriority = 1
                      + selection    = {
                          + countNumber = 100
                          + countType   = "imageCountMoreThan"
                          + tagStatus   = "any"
                        }
                    },
                ]
            }
        )
      + registry_id = (known after apply)
      + repository  = (known after apply)
    }

  # aws_ecr_repository.leman_test_ecs_kong will be created
  + resource "aws_ecr_repository" "leman_test_ecs_kong" {
      + arn                  = (known after apply)
      + id                   = (known after apply)
      + image_tag_mutability = "MUTABLE"
      + name                 = (known after apply)
      + registry_id          = (known after apply)
      + repository_url       = (known after apply)
      + tags                 = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + ecr_url = (known after apply)


Warning: Resource targeting is in effect

You are creating a plan with the -target option, which means that the result
of this plan may not represent all of the changes requested by the current
configuration.

The -target option is not for routine use, and is provided only for
exceptional situations such as recovering from errors or mistakes, or when
Terraform specifically suggests to use it as part of an error message.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_ecr_repository.leman_test_ecs_kong: Creating...
aws_ecr_repository.leman_test_ecs_kong: Creation complete after 4s [id=leman-test-ecr-kong-20210623]
aws_ecr_lifecycle_policy.leman_test_ecs_kong: Creating...
aws_ecr_lifecycle_policy.leman_test_ecs_kong: Creation complete after 2s [id=leman-test-ecr-kong-20210623]

Warning: Applied changes may be incomplete

The plan was created with the -target option in effect, so some changes
requested in the configuration may have been ignored and the output values may
not be fully updated. Run the following command to verify that no other
changes are pending:
    terraform plan

Note that the -target option is not suitable for routine use, and is provided
only for exceptional situations such as recovering from errors or mistakes, or
when Terraform specifically suggests to use it as part of an error message.


Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
Releasing state lock. This may take a few moments...

Outputs:

ecr_url = "008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623"
  ```
- docker pull image
  ```bash
  docker pull  postgres:11
  docker pull dpage/pgadmin4
  docker pull kong
  docker pull nginx
  docker pull pgbouncer/pgbouncer
  docker pull pantsel/konga
```
- tag image
  ```bash
  docker tag  postgres:11  008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:postgres_11

  docker tag dpage/pgadmin4 0008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:pgadmin4
  
  docker tag kong 008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:kong

  docker tag nginx 008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:nginx

  docker tag pgbouncer/pgbouncer 008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:pgbouncer

  docker tag pantsel/konga 008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:konga
  ```

- upload image
  ```bash
  aws ecr get-login --no-include-email --region=us-east-1|bash
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Login Succeeded

  docker push  008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:postgres_11

  docker push  0008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:pgadmin4
  
  docker push  008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:kong

  docker push  008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:nginx

  docker push  008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:pgbouncer

  docker push  008629597077.dkr.ecr.us-east-1.amazonaws.com/leman-test-ecr-kong-20210623:konga
  ```

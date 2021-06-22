## aws provider ## 



## backend  ##
terraform {
    required_version = ">= 0.14.3"
    backend "s3" {
        ## 1. running ./initial/s3-setup.sh for create s3 and dynamoDV firstly if they are no exist
        ## 2. terraform init -backend-config=dev.backend
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 2.59.0"
        }
    }
}

provider "aws" {
    region = var.region
}
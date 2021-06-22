#!/bin/bash


## create s3 bucket
function  create_bucket(){
    aws s3api create-bucket   --object-lock-enabled-for-bucket \
    --acl private  --bucket $1 \
    --region $2 \
    --create-bucket-configuration LocationConstraint=$2
}
function put_bucket_version(){
    aws s3api put-bucket-versioning --bucket $1 \
        --region $2 --versioning-configuration Status=Enabled
}
function put_bucket_encryption(){
    aws s3api put-bucket-encryption --bucket $1 \
        --region $2 \
        --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
}
function put_bucket_block_public(){
    aws s3api put-public-access-block --bucket $1 \
        --region $2 \
        --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
}
function delete_bucket(){
    aws s3api   delete-bucket --bucket $1
}



# status
function output(){
    if [ $1 != 0 ]
    then
       echo "ERROR! $2 failed"
       exit $1
    fi
    echo "$2 DONE"
}


# create dynamodb
function create_dynamodb(){
    aws dynamodb create-table --table-name $1 --no-verify-ssl \
    --region $2 \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \

}


function args(){
    if [ $ARGS -lt 2 ]
    then
        echo "Usage: $0 ENV AWS_REGION"
        echo "  ENV option:  dev|prod|staging"
        echo "  AWS_REGION option: us-east-2"
        echo "e.g. : $0 dev  us-east-2 "
        exit 1
    fi
}

function main(){
    ## create resource

    echo "==========================="
    echo "= The following resource will be created ="
    echo " S3 bucket:   ${BUCKET_NAME}"
    echo " DynamoDB Table: ${TABLE_NAME}"
    echo "Enter 'Yes' to process:"
    read answer
    if [ $answer != "Yes"  ]
    then
        echo "=== Bye ~~ ==="
        exit 99
    fi
## create s3 bucket
    echo "Creating bucket"
#    create_bucket $BUCKET_NAME $REGION
#    output $? "Create bucket"
#    put_bucket_version  $BUCKET_NAME $REGION
#    output $? "Put bucket versioning in bucket"
#    put_bucket_encryption $BUCKET_NAME $REGION
#    output $? "Put bucket encryption"
#    put_bucket_block_public $BUCKET_NAME $REGION
#    output $? "Put bucket block public access"
#    echo "S3 Bucket [${BUCKET_NAME}] configured!"
#    echo "..."

    echo "Create dynamodb (table = ${TABLE_NAME})"
## create dynamodb table
    create_dynamodb $TABLE_NAME $REGION
    output $? "Create DynamoDB Table "
    echo "DynamoDB Table [${TABLE_NAME}] created!"
}

# set env values

ARGS=$#
ENV=$1
REGION=$2
NAME_BASE="leman-terraform-state"
BUCKET_NAME=${ENV}-${NAME_BASE}   # will use
TABLE_NAME=${ENV}-${NAME_BASE}    # will use

# run
args
#delete_bucket $BUCKET_NAME
main

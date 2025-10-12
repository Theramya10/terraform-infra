#!/usr/bin/env bash
set -euo pipefail

# Customize these names (must be globally unique for S3 bucket)
AWS_REGION="ap-south-1"
TFSTATE_BUCKET="tfstate-theramya-$(openssl rand -hex 4)"  # unique suffix
DYNAMO_TABLE="tfstate-lock-theramya"

echo "Creating S3 bucket for Terraform state: ${TFSTATE_BUCKET} (${AWS_REGION})"
aws s3api create-bucket \
  --bucket "${TFSTATE_BUCKET}" \
  --region "${AWS_REGION}" \
  --create-bucket-configuration LocationConstraint=${AWS_REGION}

echo "Enable versioning on state bucket"
aws s3api put-bucket-versioning --bucket "${TFSTATE_BUCKET}" --versioning-configuration Status=Enabled

echo "Create DynamoDB table for state locking: ${DYNAMO_TABLE}"
aws dynamodb create-table \
  --table-name "${DYNAMO_TABLE}" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region "${AWS_REGION}"

echo "Done. Please update terraform/backend.tf with bucket name: ${TFSTATE_BUCKET} and table: ${DYNAMO_TABLE}"

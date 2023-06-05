#!/bin/bash 

ecr=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
image=${ecr}/${SERVICE_NAME}_${CI_COMMIT_REF_NAME}:latest

# login
aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ecr}

# push image
docker push ${image}

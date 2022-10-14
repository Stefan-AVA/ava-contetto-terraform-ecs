#!/bin/bash 

key=AWS_ACCESS_KEY_ID_${CI_COMMIT_REF_NAME}
sec=AWS_SECRET_ACCESS_KEY_${CI_COMMIT_REF_NAME}
export AWS_ACCESS_KEY_ID=${!key}
export AWS_SECRET_ACCESS_KEY=${!sec}

ecr=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
image=${ecr}/${SERVICE_NAME}_${CI_COMMIT_REF_NAME}:latest

# login
aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ecr}

# push image
docker push ${image}

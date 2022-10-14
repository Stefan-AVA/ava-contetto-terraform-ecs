#!/bin/bash

echo "${ENV_FILE}" > .env

ecr=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
image=${ecr}/${SERVICE_NAME}_${CI_COMMIT_REF_NAME}:latest

docker build -t ${image} .

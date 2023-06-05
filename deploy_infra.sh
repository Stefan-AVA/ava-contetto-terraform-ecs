#!/bin/bash

export TF_VAR_app_name=${APP_NAME}
export TF_VAR_service_name=${SERVICE_NAME}
export TF_VAR_env=${CI_COMMIT_REF_NAME}
export TF_VAR_region=${AWS_DEFAULT_REGION}
export TF_VAR_ecr=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
export TF_VAR_repo_name=${SERVICE_NAME}_${CI_COMMIT_REF_NAME}
export TF_VAR_path_pattern=${PATH_PATTERN}
export TF_VAR_container_port=${CONTAINER_PORT}
export TF_VAR_health_check_path=${HEALTH_CHECK_PATH}

export TF_VAR_vpc_id=${VPC_ID}
export TF_VAR_subnet_ids=${SUBNET_IDS}
export TF_VAR_listener_arn=${LISTNER_ARN}
export TF_VAR_cluster_name=${CLUSTER_NAME}
export TF_VAR_cluster_id=arn:aws:ecs:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:cluster/${CLUSTER_NAME}

if [ -z "$MAX_CAPACITY"]
then
    export TF_VAR_max_capacity=3
else
    export TF_VAR_max_capacity=${MAX_CAPACITY}
fi
if [ -z "$MIN_CAPACITY"]
then
    export TF_VAR_min_capacity=1
else
    export TF_VAR_min_capacity=${MIN_CAPACITY}
fi
if [ -z "$DESIRED_COUNT"]
then
    export TF_VAR_desired_count=1
else
    export TF_VAR_desired_count=${DESIRED_COUNT}
fi
if [ -z "$CPU"]
then
    export TF_VAR_cpu=256
else
    export TF_VAR_cpu=${CPU}
fi
if [ -z "$MEMORY"]
then
    export TF_VAR_memory=512
else
    export TF_VAR_memory=${MEMORY}
fi

terraform -chdir="terraform" init \
    -backend-config="bucket=${BUCKET_NAME}" \
    -backend-config="key=${APP_NAME}/${SERVICE_NAME}/${CI_COMMIT_REF_NAME}.tfstate" \
    -backend-config="region=${AWS_BUCKET_REGION}"



if ${DO_DESTROY}
then
    terraform -chdir="terraform" destroy --auto-approve
else
    terraform -chdir="terraform" apply --auto-approve
fi

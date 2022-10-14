#!/bin/bash

key=AWS_ACCESS_KEY_ID_${CI_COMMIT_REF_NAME}
sec=AWS_SECRET_ACCESS_KEY_${CI_COMMIT_REF_NAME}
export AWS_ACCESS_KEY_ID=${!key}
export AWS_SECRET_ACCESS_KEY=${!sec}

export TF_VAR_app_name=${APP_Name}
export TF_VAR_service_name=${SERVICE_NAME}
export TF_VAR_env=${CI_COMMIT_REF_NAME}
export TF_VAR_region=${AWS_DEFAULT_REGION}
export TF_VAR_ecr=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
export TF_VAR_repo_name=${SERVICE_NAME}_${CI_COMMIT_REF_NAME}
export TF_VAR_path_pattern=${PATH_PATTERN}
export TF_VAR_container_port=${CONTAINER_PORT}

vpc_id=VPC_ID_${CI_COMMIT_REF_NAME}
subnet_ids=SUBNET_IDS_${CI_COMMIT_REF_NAME}
listener_arn=LISTNER_ARN_${CI_COMMIT_REF_NAME}
cluster_name=CLUSTER_NAME_${CI_COMMIT_REF_NAME}

export TF_VAR_vpc_id=${!vpc_id}
export TF_VAR_subnet_ids=${!subnet_ids}
export TF_VAR_listener_arn=${!listener_arn}
export TF_VAR_cluster_name=${!cluster_name}
export TF_VAR_cluster_id=arn:aws:ecs:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:cluster/${!cluster_name}

terraform -chdir="terraform" init \
    -backend-config="bucket=${BUCKET_NAME}" \
    -backend-config="key=${APP_Name}/${SERVICE_NAME}/${CI_COMMIT_REF_NAME}.tfstate" \
    -backend-config="region=${AWS_DEFAULT_REGION}"



if ${DO_DESTROY}
then
    terraform -chdir="terraform" destroy --auto-approve
else
    terraform -chdir="terraform" apply --auto-approve
fi

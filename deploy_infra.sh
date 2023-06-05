#!/bin/bash

export TF_VAR_account_id=${AWS_ACCOUNT_ID}
export TF_VAR_app_name=${APP_NAME}
export TF_VAR_service_name=${SERVICE_NAME}
export TF_VAR_env=${CI_COMMIT_REF_NAME}
export TF_VAR_region=${AWS_DEFAULT_REGION}
export TF_VAR_ecr=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
export TF_VAR_repo_name=${SERVICE_NAME}_${CI_COMMIT_REF_NAME}

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

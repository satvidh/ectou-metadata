#!/usr/bin/env bash

if [[ -z ${POD_ROLE_NAME} ]]; then
    echo "POD_ROLE_NAME environment variable must provide the name of the pod role. "
    exit 1
fi

if [[ -z ${CHARTS_PATH} ]]; then
    echo "CHARTS_PATH environment variable must provide relative path "
    echo "to the helm chart path."
    exit 1
fi

if [[ -z ${KUBERNETES_NAMESPACE} ]]; then
    echo "KUBERNETES_NAMESPACE environment variable must provide the name of the "
    echo "kubernetes namespace to deploy into."
    exit 1
fi

if [[ -z ${HELM_NAME} ]]; then
    echo "HELM_NAME environment variable must provide the name for the chart."
    exit 1
fi

if [[ -z ${AWS_DEFAULT_REGION} ]]; then
    echo "AWS_DEFAULT_REGION environment variable must provide the name of the region."
    exit 1
fi

if [[ -z ${IMAGE_NAME} ]]; then
    echo "IMAGE_NAME environment variable must provide the name of the docker image for the example."
    exit 1
fi

if [[ -z ${IMAGE_TAG} ]]; then
    echo "IMAGE_TAG environment variable must provide the tag of the docker image for the example."
    exit 1
fi

if [[ ! -z ${DEBUG} ]] && [[ "${DEBUG}"=="true" ]]; then
    echo "DEBUG is set to ${DEBUG}"
    echo "Will dry-run"
    ADDITIONAL_PARAMETERS="--dry-run --debug"
fi

helm install ${HELM_NAME} ${CHARTS_PATH}/mock_ec2_metadata \
    --atomic \
    -n ${KUBERNETES_NAMESPACE} \
    ${ADDITIONAL_PARAMETERS} \
    --set aws.accountId=$(aws sts get-caller-identity | jq .Account -r)  \
    --set aws.podRoleName=${POD_ROLE_NAME} \
    --set aws.accessKeyId=${AWS_ACCESS_KEY_ID} \
    --set aws.secretAccessKey=${AWS_SECRET_ACCESS_KEY} \
    --set aws.sessionToken=${AWS_SESSION_TOKEN} \
    --set aws.region=${AWS_DEFAULT_REGION}

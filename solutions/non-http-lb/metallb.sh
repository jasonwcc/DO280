#!/bin/bash

SKU=DO280
LAB=non-http-lb

LABS_DIR="${HOME}/${SKU}/labs/${LAB}"
SOLUTIONS_DIR="${HOME}/${SKU}/solutions/${LAB}"

METALLB_NAMESPACE=metallb-system

RHT_OCP4_USER_NAME="admin"
RHT_OCP4_USER_PASSWD="redhatocp"
RHT_OCP4_MASTER_API="https://api.ocp4.example.com:6443"

export TERM=linux
export NO_COLOR=1
export KUBECONFIG="${SOLUTIONS_DIR}/kubeconfig.yaml"

set -exuo pipefail

pwd
mkdir -vp "${SOLUTIONS_DIR}"
touch "${KUBECONFIG}"
pushd "${SOLUTIONS_DIR}"

oc login -u "${RHT_OCP4_USER_NAME}" -p "${RHT_OCP4_USER_PASSWD}" "${RHT_OCP4_MASTER_API}"

oc project "${METALLB_NAMESPACE}"
oc apply -f metallb.yaml

oc rollout restart deployment/controller
kubectl rollout status deployment/controller --watch
oc wait --for condition=available deployment/controller

oc rollout restart daemonset/speaker
kubectl rollout status daemonset/speaker

popd

rm -v "${KUBECONFIG}"

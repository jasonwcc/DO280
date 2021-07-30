#!/bin/sh

. /usr/local/etc/ocp4.config

THIS_SCRIPT=$(realpath "$0")
PARENT_DIR=$(dirname "$THIS_SCRIPT")
RESOURCE_FILE="${PARENT_DIR}/hello-app.yaml"

# If needed, replace 
sed -i "s/RHT_OCP4_WILDCARD_DOMAIN/$RHT_OCP4_WILDCARD_DOMAIN/g" "$RESOURCE_FILE"

oc create -f "$RESOURCE_FILE"



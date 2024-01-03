#!/bin/bash
lab_name="network-review"
lab_path="../../labs/${lab_name}"
oc project ${lab_name}
oc delete secret passthrough-cert
oc create secret tls passthrough-cert --cert ${lab_path}/certs/product.pem --key ${lab_path}/certs/product.key

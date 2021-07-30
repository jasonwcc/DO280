#!/bin/bash
#
# Run this script to retrieve the definition of the 'KubeCPUOvercommit' alert.
#

source /usr/local/etc/ocp4.config
echo ''
echo -n ' · Connecting to OpenShift as the admin user: '
if oc login -u admin -p ${RHT_OCP4_USER_PASSWD} ${RHT_OCP4_MASTER_API} >/dev/null 2>&1; then
  echo -e '\tOK'
else
  echo -e '\tFAIL'
  exit 1
fi

echo -n ' · Using openshift-monitoring project: '
if oc project openshift-monitoring >/dev/null; then
  echo -e '\t\tOK'
else
  echo 'FAIL'
  exit 1
fi

echo ' · Retrieving alert expression: '
# FIXME - need to use the index to retrieve the first element.
# May not be possible -- see [https://github.com/json-path/JsonPath/issues/272]
oc get prometheusrules -o jsonpath='{.items[0].spec.groups[?(@.name=="kubernetes-resources")].rules[?(@.alert=="KubeCPUOvercommit")].expr}{"\n"}' | head -5
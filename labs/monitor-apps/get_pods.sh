#!/bin/sh


#oc get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}'

# Display the pod names; filter out deploy pods
oc get pods -o custom-columns=NAME:.metadata.name --no-headers | grep -v deploy

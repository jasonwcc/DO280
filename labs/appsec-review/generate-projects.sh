#!/bin/bash

curr_project="$(oc project --short)"
label_name="appsec-review-cleaner"
proj_base_name="obsolete-appsec-review"
kubeconfig_file="/home/student/.auth/ocp4-kubeconfig"

for i in {1..3}
  do
    proj_name="$proj_base_name-$i"
    oc new-project $proj_name 2>&1 > /dev/null
    echo "$proj_name project created at $(date +"%H:%M:%S")"
  done

for i in {1..3}
 do
   proj_name="$proj_base_name-$i"
   KUBECONFIG=$kubeconfig_file oc label  ns $proj_name "$label_name="
 done

 echo "Last $label_name label applied at $(date +"%H:%M:%S")"
 echo "Done"
 oc project $curr_project;






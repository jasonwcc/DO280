#!/bin/sh

source /usr/local/etc/ocp4.config

while true; do

  curl hello-monitor-apps.${RHT_OCP4_WILDCARD_DOMAIN}
  sleep 0.5

done

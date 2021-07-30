#!/bin/sh

oc create -f dc-hello.yml
oc expose dc/hello --port 80 --target-port 3000
oc expose svc/hello



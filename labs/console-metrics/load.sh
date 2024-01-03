#!/bin/bash

function poll {
  local iterations="$1"
  local duration="$2"
  local endpoint="http://books-console-apps.apps.ocp4.example.com/leak"

  echo "Polling ${endpoint} every ${duration} seconds ${iterations} times..."

  for ((i=0; i < $iterations; i++))
  do
    curl -s -o /dev/null ${endpoint}
    sleep ${duration}
  done
}

test -f ~/DO280/labs/console-metrics/executed && {
  echo "This script should only be run once. Memory usage might take a while to appear in the console"
  exit 1
}

# Poll the leak endpoint. We start fast so that we see immediate results.
poll 300 0
touch ~/DO280/labs/console-metrics/executed

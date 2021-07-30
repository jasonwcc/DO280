#!/bin/sh

# Seconds
SLEEP_INTERVAL=1

# Repeatedly query each pod, unless a 
# command line argument is passed.
while true; do
    # Output the current time
    echo "Current time: $(date +'%H:%M:%S')"

    # For each pod:
    #  1. RSH to the pod
    #  2. curl localhost:3001/ready
    for pod in $(./get_pods.sh); do
        oc rsh $pod curl localhost:3001/ready
    done

    # If the script is executed with no command-line arguments,
    # then the first argument will have a length of zero.
    # In this case, exit the while loop.
    if [ -z $1 ]; then
        break
    fi

    # To reach this command, the script has to have a command-line argument
    # passed, like: $> pod_ready_status.sh --loop
    sleep $SLEEP_INTERVAL
    echo ""
done

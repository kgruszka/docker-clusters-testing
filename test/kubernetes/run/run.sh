#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKER_COUNT=$1
#array=( 10 20 50 100 )
array=( 10 20 30 )
IMAGE="nginx"
#IMAGE="pearman/mt_start-containers"

wait_for_deletion () {
    local running_pods=$(kubectl get pods)
    while [ -n "$running_pods" ]; do
        running_pods=$(kubectl get pods)
        printf "deletion progress: \n$running_pods\n" >> $SCRIPT_DIR/cleanup.log
        sleep 1
    done
    printf "deletion completed" >> $SCRIPT_DIR/cleanup.log
}

wait_for_test_completed () {
    local NAME=$1
    local desired=$2
    local current=0
    while [ "$desired" != "$current" ]; do
        current=$(kubectl describe deployment $NAME | grep "Replicas:" | awk '{print $11}')
        echo "desired deployment count: $desired, running: $current" >> $SCRIPT_DIR/deployment.log
        sleep 1
    done
    echo "deployment completed: $desired, running: $current" >> $SCRIPT_DIR/deployment.log
}

run_test () {
    local NAME=$1
    local REPLICAS=$2
    kubectl run $NAME --image=$IMAGE --replicas $REPLICAS
    wait_for_test_completed $NAME $REPLICAS
}

cleanup () {
    local NAME=$1
    kubectl delete deployment $NAME
    wait_for_deletion
}

for REPLICAS in "${array[@]}"
do
    run_test test-start $(($REPLICAS * $WORKER_COUNT))
    cleanup test-start
done


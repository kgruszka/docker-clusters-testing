#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_DIR=$SCRIPT_DIR/log
WORKER_COUNT=$1
AGENT_HOST=$2
AGENT_PORT=$3
array=( 10 25 50 100 )
#IMAGE="pearman/mt_start-containers"
IMAGE="pearman/mt_start_stop_test"

wait_for_deletion () {
    local running_pods=$(kubectl get pods)
    while [ -n "$running_pods" ]; do
        running_pods=$(kubectl get pods)
        printf "deletion progress: \n$running_pods\n" >> $LOG_DIR/cleanup.log
        sleep 1
    done
    printf "deletion completed" >> $LOG_DIR/cleanup.log
}

wait_for_test_completed () {
    local NAME=$1
    local desired=$2
    local current=0
    while [ "$desired" != "$current" ]; do
        current=$(kubectl get pods | grep "$NAME" | grep -c "Running")
        echo "desired deployment count: $desired, running: $current" >> $LOG_DIR/deployment.log
        sleep 1
    done
    echo "deployment completed: $desired, running: $current" >> $LOG_DIR/deployment.log
}

run_test () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    local REPLICAS=$(($REPLICAS_PER_NODE * $WORKER_COUNT))
    timestamp=$(echo "console.log(Date.now())" | node)
    kubectl run $NAME --image=$IMAGE --replicas=$REPLICAS --env="TEST_NAME=$REPLICAS_PER_NODE" --env="AGENT_PORT=3000" --env="AGENT_HOST=172.17.0.1"
    curl -X POST -H "Content-Type: application/json" -d "{\"start\":$timestamp, \"step\":\"$REPLICAS_PER_NODE\", \"test\":\"start\"}" $AGENT_HOST:$AGENT_PORT
    wait_for_test_completed $NAME $REPLICAS
}

cleanup () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    timestamp=$(echo "console.log(Date.now())" | node)
    kubectl delete deployment $NAME
    curl -X POST -H "Content-Type: application/json" -d "{\"start\":$timestamp, \"step\":\"$REPLICAS_PER_NODE\", \"test\":\"delete\"}" $AGENT_HOST:$AGENT_PORT
    wait_for_deletion
}

mkdir -p $LOG_DIR
for REPLICAS in "${array[@]}"
do
    run_test test-start $REPLICAS
    cleanup test-start $REPLICAS
done


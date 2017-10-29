#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_DIR=$SCRIPT_DIR/log
WORKER_COUNT=$1
AGENT_HOST=$2
AGENT_PORT=$3
array=( 10 25 50 100 )
IMAGE_V1="pearman/mt_update_test:v1"
IMAGE_V2="pearman/mt_update_test:v2"

wait_for_deletion () {
    local running_pods=$(kubectl get pods)
    while [ -n "$running_pods" ]; do
        running_pods=$(kubectl get pods)
        printf "deletion progress: \n$running_pods\n" >> $LOG_DIR/cleanup.log
        sleep 1
    done
    sleep 10
    printf "deletion completed" >> $LOG_DIR/cleanup.log
}

wait_for_test_completed () {
    local NAME=$1
    local desired=$2
    local current=0
    sleep 10
    while [ "$desired" != "$current" ]; do
        current=$(kubectl get deployment $NAME | grep "$NAME" | awk '{print $4}')
        echo "desired deployment count: $desired, running: $current" >> $LOG_DIR/deployment.log
        sleep 1
    done
    sleep 10
    echo "update completed: $desired, running: $current" >> $LOG_DIR/deployment.log
}

wait_for_service_running () {
    local NAME=$1
    local desired=$2
    local current=0
    while [ "$desired" != "$current" ]; do
        current=$(kubectl get pods | grep "$NAME" | grep -c "Running")
        echo "desired deployment count: $desired, running: $current" >> $LOG_DIR/deployment.log
        sleep 1
    done
    sleep 10
    echo "deployment completed: $desired, running: $current" >> $LOG_DIR/deployment.log
}

run_service () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    local REPLICAS=$(($REPLICAS_PER_NODE * $WORKER_COUNT))
    kubectl run $NAME --image=$IMAGE_V1 --replicas=$REPLICAS --env="TEST_NAME=$REPLICAS_PER_NODE" --env="AGENT_PORT=3000" --env="AGENT_HOST=172.17.0.1"
    wait_for_service_running $NAME $REPLICAS
}

update_service () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    local REPLICAS=$(($REPLICAS_PER_NODE * $WORKER_COUNT))
    timestamp=$(echo "console.log(Date.now())" | node)
    kubectl set image deployment/$NAME $NAME=$IMAGE_V2
    curl -X POST -H "Content-Type: application/json" -d "{\"start\":$timestamp, \"step\":\"$REPLICAS_PER_NODE\", \"test\":\"update\"}" $AGENT_HOST:$AGENT_PORT
    wait_for_test_completed $NAME $REPLICAS
}

cleanup () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    kubectl delete deployment $NAME
    wait_for_deletion
}

mkdir -p $LOG_DIR
for REPLICAS in "${array[@]}"
do
    run_service test-start $REPLICAS
    update_service test-start $REPLICAS
    cleanup test-start $REPLICAS
done


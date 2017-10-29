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
    local running_containers=$(docker node ps $(docker node ls | awk 'NR>1 {print $1}' | paste -sd ' ' -) | awk 'NR>1')
    while [ -n "$running_containers" ]; do
        running_containers=$(docker node ps $(docker node ls | awk 'NR>1 {print $1}' | paste -sd ' ' -) | awk 'NR>1')
        printf "deletion progress: \n$running_containers\n" >> $SCRIPT_DIR/cleanup.log
        sleep 1
    done
    sleep 10
    printf "deletion completed" >> $SCRIPT_DIR/cleanup.log
}

wait_for_service_running () {
    local NAME=$1
    local desired=$2
    local current=0
    while [ "$desired" != "$current" ]; do
        current=$(docker service ps $NAME | grep "$IMAGE_V1" | grep -c "Running")
        echo "desired service count: $desired, running: $current" >> $SCRIPT_DIR/deployment.log
        sleep 1
    done
    sleep 10
    echo "deployment completed: $desired, running: $current" >> $SCRIPT_DIR/deployment.log
}

wait_for_test_completed () {
    local NAME=$1
    local desired=$2
    local current=0
    sleep 10
    while [ "$desired" != "$current" ]; do
        current=$(docker service ps $NAME | grep "$IMAGE_V2" | grep -c "Running")
        echo "desired deployment count: $desired, running: $current" >> $LOG_DIR/deployment.log
        sleep 1
    done
    sleep 10
    echo "update completed: $desired, running: $current" >> $LOG_DIR/deployment.log
}

run_service () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    local REPLICAS=$(($REPLICAS_PER_NODE * $WORKER_COUNT))
    docker service create --name $NAME --replicas $REPLICAS -e TEST_NAME=$REPLICAS_PER_NODE -e AGENT_PORT=3000 -e AGENT_HOST=172.17.0.1 $IMAGE_V1
    wait_for_service_running $NAME $REPLICAS
}

update_service () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    local REPLICAS=$(($REPLICAS_PER_NODE * $WORKER_COUNT))
    timestamp=$(echo "console.log(Date.now())" | node)
    docker service update --update-order "start-first" --update-parallelism 1 --image $IMAGE_V2 $NAME
    curl -X POST -H "Content-Type: application/json" -d "{\"start\":$timestamp, \"step\":\"$REPLICAS_PER_NODE\", \"test\":\"update\"}" $AGENT_HOST:$AGENT_PORT
    wait_for_test_completed $NAME $REPLICAS
}

cleanup () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    docker service rm $NAME
    wait_for_deletion
}

mkdir -p $LOG_DIR
for REPLICAS in "${array[@]}"
do
    run_service test-start $REPLICAS
    update_service test-start $REPLICAS
    cleanup test-start $REPLICAS
done
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
    local running_containers=$(docker node ps $(docker node ls | awk 'NR>1 {print $1}' | paste -sd ' ' -) | awk 'NR>1')
    while [ -n "$running_containers" ]; do
        printf "deletion progress: \n$running_containers\n" >> $SCRIPT_DIR/cleanup.log
        sleep 1
    done
    printf "deletion completed" >> $SCRIPT_DIR/cleanup.log
}

wait_for_test_completed () {
    local NAME=$1
    local desired=$2
    local current=0
    while [ "$desired" != "$current" ]; do
        current=$(docker service ps $NAME | grep "$IMAGE" | grep -c "Running")
        echo "desired service count: $desired, running: $current" >> $SCRIPT_DIR/deployment.log
        sleep 1
    done
    echo "deployment completed: $desired, running: $current" >> $SCRIPT_DIR/deployment.log
}

run_test () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    local REPLICAS=$(($REPLICAS_PER_NODE * $WORKER_COUNT))
    timestamp=$(echo "console.log(Date.now())" | node)
    docker service create --name $NAME --replicas $REPLICAS -e TEST_NAME=$REPLICAS_PER_NODE -e AGENT_PORT=3000 -e AGENT_HOST=172.17.0.1 $IMAGE
    curl -X POST -H "Content-Type: application/json" -d "{\"start\":$timestamp, \"step\":\"$REPLICAS_PER_NODE\", \"test\":\"start\"}" $AGENT_HOST:$AGENT_PORT
    wait_for_test_completed $NAME $REPLICAS
}

cleanup () {
    local NAME=$1
    local REPLICAS_PER_NODE=$2
    timestamp=$(echo "console.log(Date.now())" | node)
    docker service rm $NAME
    curl -X POST -H "Content-Type: application/json" -d "{\"start\":$timestamp, \"step\":\"$REPLICAS_PER_NODE\", \"test\":\"delete\"}" $AGENT_HOST:$AGENT_PORT
    wait_for_deletion
}

mkdir -p $LOG_DIR
for REPLICAS in "${array[@]}"
do
    run_test test-start $REPLICAS
    cleanup test-start $REPLICAS
done

#docker service create --restart-condition none -e AGENT_PORT=3000 -e AGENT_HOST=172.17.0.1 --replicas 5 pearman/mt_start-containers

#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKER_COUNT=$1
#array=( 10 20 50 100 )
array=( 10 20 30 )
IMAGE="nginx"
#IMAGE="pearman/mt_start-containers"

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
        current=$(docker service ls | grep $NAME | awk '{print $4}' | awk -F'/' '{print $1}')
        echo "desired service count: $desired, running: $current" >> $SCRIPT_DIR/deployment.log
        sleep 1
    done
    echo "deployment completed: $desired, running: $current" >> $SCRIPT_DIR/deployment.log
}

run_test () {
    local NAME=$1
    local REPLICAS=$2
    docker service create --name $NAME --replicas $REPLICAS $IMAGE
    wait_for_test_completed $NAME $REPLICAS
}

cleanup () {
    local NAME=$1
    docker service rm $NAME
    wait_for_deletion
}

for REPLICAS in "${array[@]}"
do
    run_test test-start $(($REPLICAS * $WORKER_COUNT))
    cleanup test-start
done

#docker service create --restart-condition none -e AGENT_PORT=3000 -e AGENT_HOST=172.17.0.1 --replicas 5 pearman/mt_start-containers

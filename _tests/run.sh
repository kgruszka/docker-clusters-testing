#!/bin/bash
# . ./export_aws.sh && terraform apply -target=module.db_service
DEBUG=$1
STORAGE_HOST="35.156.118.192"
STORAGE_PORT="8080"
STORAGE_AUTH="YWRtaW46Y2hhbmdlaXQ="
MASTER_NODES_COUNT=1
SLAVE_NODES_COUNT=1
CONTAINERS_COUNT=5

# sh tests/start_containers.sh 2 2 15 $STORAGE_HOST $STORAGE_PORT $STORAGE_AUTH $DEBUG

if [ -z "$DEBUG" ] ; then
    # sh tests/start_containers.sh 1 3 20 $STORAGE_HOST $STORAGE_PORT $STORAGE_AUTH
    sh tests/start_containers_test.sh 3 2 50 $STORAGE_HOST $STORAGE_PORT $STORAGE_AUTH
fi
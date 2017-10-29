#!/bin/sh
#SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#
#wait_for_ds_start () {
#    local DS_NAME=$1
#    local desired=$(kubectl describe ds $DS_NAME | grep "Desired" | awk '{print 6}')
#    local current=$(kubectl describe ds $DS_NAME | grep "Current" | awk '{print 6}')
#    while [ "$desired" != "$current" ]; do
#        echo "desired daemonsets count: $desired, running: $current" >> $SCRIPT_DIR/pull.log
#        sleep 1
#    done
#}
#
#wait_for_ds_deletion () {
#    local running_pods=$(kubectl get pods)
#    while [ -n "$running_pods" ]; do
#        printf "deletion progress: \n$running_pods\n" >> $SCRIPT_DIR/cleanup.log
#        sleep 1
#    done
#}
#
#pull_images () {
#    export IMAGE=$1
#    export DS_NAME="pull"
#
#    cat $SCRIPT_DIR/ds_template.yml | envsubst > $SCRIPT_DIR/image_pull.yml
#    kubectl create -f $SCRIPT_DIR/image_pull.yml
#
#    wait_for_ds_start $DS_NAME
#
#    kubectl delete ds $DS_NAME
#
#    wait_for_ds_deletion
#}
#
#pull_images "pearman/mt_start-containers"
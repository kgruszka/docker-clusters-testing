#!/bin/bash
STORAGE_HOST=$1
STORAGE_PORT=$2
STORAGE_AUTH=$3
STORAGE_PATH=$4
sudo chmod +x test/agent/init.sh && sudo sh test/agent/init.sh $STORAGE_HOST $STORAGE_PORT $STORAGE_AUTH $STORAGE_PATH
sudo docker pull pearman/mt_start-containers
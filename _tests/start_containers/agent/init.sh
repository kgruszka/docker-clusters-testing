#!/bin/bash
STORAGE_HOST=$1
STORAGE_PORT=$2
STORAGE_AUTH=$3
STORAGE_PATH=$4
cd test/agent
sudo npm install
#sudo STORAGE_HOST=$STORAGE_HOST STORAGE_PORT=$STORAGE_PORT STORAGE_AUTH=$STORAGE_AUTH STORAGE_PATH=$STORAGE_PATH nohup npm start &
sudo STORAGE_HOST=$STORAGE_HOST STORAGE_PORT=$STORAGE_PORT STORAGE_AUTH=$STORAGE_AUTH STORAGE_PATH=$STORAGE_PATH forever start -l forever.log -o out.log -e err.log index.js
cd ../../
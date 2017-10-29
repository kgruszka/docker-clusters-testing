#!/bin/bash
cwd="$(pwd)"
cd "$(dirname "$0")"

DB_HOST=$1
DB_PORT=$2
DB_PATH=$3
DB_AUTH=$4

sudo npm install
sudo STORAGE_HOST=$DB_HOST STORAGE_PORT=$DB_PORT STORAGE_PATH=$DB_PATH STORAGE_AUTH=$DB_AUTH forever start -a -l forever.log -o out.log -e err.log --uid agent index.js

cd $cwd
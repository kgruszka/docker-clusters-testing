#!/bin/bash
AGENT_HOST=$1
AGENT_PORT=$2
CONTAINERS_COUNT=$3
timestamp=$(sudo sh test/start.sh $CONTAINERS_COUNT | head -n 1)

curl -X POST -H "Content-Type: application/json" -d "{\"start\":$timestamp}" $AGENT_HOST:$AGENT_PORT

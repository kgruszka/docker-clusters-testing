#!/bin/bash

docker kill --signal="SIGTERM" $(docker ps | awk 'NR==2 {print $1}')

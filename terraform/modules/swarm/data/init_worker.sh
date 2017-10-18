#!/bin/sh
SWARM_MASTER_IP=${SWARM_MASTER_IP}

sudo docker swarm join $SWARM_MASTER_IP:2377 --token $(docker -H $SWARM_MASTER_IP swarm join-token -q worker)
#!/bin/sh
SWARM_MASTER_IP=${SWARM_MASTER_IP}

sudo systemctl stop docker
sudo nohup dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock &
sudo docker swarm join $SWARM_MASTER_IP:2377 --token $(docker -H $SWARM_MASTER_IP swarm join-token -q manager)
docker node update --availability drain $(docker node ls | grep "*" | awk '{print $1}')

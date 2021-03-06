#!/bin/sh

sudo systemctl stop docker
sudo nohup dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock &
docker swarm init
docker node update --availability drain $(docker node ls | grep "*" | awk '{print $1}')
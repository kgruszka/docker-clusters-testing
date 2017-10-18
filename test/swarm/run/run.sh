echo "tested"

date +%s%N
docker service create --restart-condition none -e AGENT_PORT=3000 -e AGENT_HOST=172.17.0.1 --replicas 5 pearman/mt_start-containers

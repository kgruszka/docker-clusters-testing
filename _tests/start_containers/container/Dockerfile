FROM karlherler/pause
RUN apk update && apk add curl

CMD curl --header "Content-Type:application/json" --data '{"timestamp": 23}' -X POST http://$AGENT_HOST:$AGENT_PORT && /bin/pause
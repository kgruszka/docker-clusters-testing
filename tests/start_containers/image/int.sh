#!/bin/sh
set -x

# SIGTERM-handler
term_handler() {
  curl --header "Content-Type:application/json" --data "{\"step\": \"$TEST_NAME\", \"test\": \"delete\"}" -X POST http://$AGENT_HOST:$AGENT_PORT
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

curl --header "Content-Type:application/json" --data "{\"step\": \"$TEST_NAME\", \"test\": \"start\"}" -X POST http://$AGENT_HOST:$AGENT_PORT

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
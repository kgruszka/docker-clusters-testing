#!/bin/sh
set -x

# SIGTERM-handler
term_handler() {
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done


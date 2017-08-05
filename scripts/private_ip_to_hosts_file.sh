#!/usr/bin/env bash
PRIVATE_IP=$1
sudo sed -i "s/\blocalhost\b/& $(echo ip-$PRIVATE_IP | sed -e 's/\./-/g')/" /etc/hosts

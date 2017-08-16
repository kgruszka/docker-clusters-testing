#!/usr/bin/env bash
ifconfig docker0 | grep "inet " | awk -F'[: ]+' '{print $4}'
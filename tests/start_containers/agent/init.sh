#!/bin/sh

cd test/agent
sudo npm install
sudo nohup npm start &
cd ../../
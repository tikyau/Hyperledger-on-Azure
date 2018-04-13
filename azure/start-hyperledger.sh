#!/bin/bash
sudo apt-get install npm
git clone https://github.com/oscarkoe/hyperledger-on-azure.git
cd hyperledger-on-azure
npm install
docker-compose up

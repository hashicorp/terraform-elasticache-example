#!/bin/bash

sudo apt-get update
sudo apt-get install -y golang

# Install test application
mkdir -p /home/ubuntu/go
chown -R ubuntu /home/ubuntu/go
export GOPATH=/home/ubuntu/go

## Fetch packages
go get github.com/bradfitz/gomemcache/memcache
go get github.com/nicholasjackson/elasticache-example/client

## Build test application
cd $GOPATH/src/github.com/nicholasjackson/elasticache-example/client
go build -o elasticache .
sudo mv ./elasticache /usr/local/bin

#!/bin/bash

sudo apt-get update
sudo apt-get install -y golang

# Install Go and test application
mkdir -p /home/ubuntu/go
chown -R ubuntu /home/ubuntu/go
export GOPATH=/home/ubuntu/go
go get github.com/bradfitz/gomemcache/memcache

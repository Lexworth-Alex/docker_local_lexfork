#!/bin/bash

sudo mkdir -p /opt/docker_config_files/

echo "Deploying webapp containers..."
docker pull lexworth2539/acada-web:latest

echo "Creating network (ignore error if exists)"
docker network create acada-app || true

# Deploy app containers
for i in {1..6}; do
  docker stop acada-webapp$i && docker rm -f acada-webapp$i || true
  docker run -d --name acada-webapp$i --hostname acada-webapp$i --network acada-app lexworth2539/acada-web:latest
  echo "Deployed acada-webapp$i"
done

sleep 10

echo "Deploying HAProxy container..."
docker rm -f haproxy || true
docker run -d --name haproxy --network acada-app \
  -v /opt/docker_config_files/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
  -p 8080:80 haproxy:latest

docker ps | grep haproxy
echo "HAProxy deployment done successfully"

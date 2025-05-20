#!/bin/bash

echo "Deploying webapp containers..."
docker pull lexworth2539/haproxy:latest

echo "Creating network"
docker network create acada-app

for i in {1..6};
do
docker stop acada-webapp$i ; docker rm -f acada-webapp$i || true
docker run -d --name acada-webapp$i --hostname acada-webapp$i --network acada-app lexworth2539/haproxy:latest;
echo "Deploying webapp$i container done"
done


slep 10
echo "Deploying HAproxy containers..."
docker rm haproxy -f >/dev/null 2>&1 || true
docker run -d --name haproxy --network acada-app -v /opt/docker_config_files/haproxy.config:/usr/local/etc/haproxy/haproxy.cfg:ro -p 9090:80 haproxy:latest
docker ps | grep -i haproxy*
echo "Deploying HAproxy containers done and succefull"

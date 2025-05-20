#!/bin/bash

echo "Deploying webapp containers..."
docker pull lexworth2539/haproxy:latest
docker stop acada-webapp1 acada-webapp2 accada-webapp3 acada-webappp4 acada-webapp5 acada-webapp-alex || true
docker rm acada-wepp1 acada-webapp2 acada-webapp3 acada-webapp4 acada-webapp5 acada-webapp-alex -f
docker network create acada-app
docker run -d --name acada-webapp1 --hostname acada-webapp1 --network acada-app lexworth2539/haproxy:latest
docker run -d --name acada-webapp2 --hostname acada-webapp2 --network acada-app lexworth2539/haproxy:latest
docker run -d --name acada-webapp3 --hostname acada-webapp3 --network acada-app lexworth2539/haproxy:latest
docker run -d --name acada-webapp4 --hostname acada-webapp4 --network acada-app lexworth2539/haproxy:latest
docker run -d --name acada-webapp5 --hostname acada-webapp5 --network acada-app lexworth2539/haproxy:latest
docker run -d --name acada-webapp-alex --hostname acada-webapp-alex --network acada-app lexworth2539/haproxy:latest
docker ps | grep -i acada-webapp*
echo "Deploying HAproxy containers done and successful"

slep 10
echo "Deploying HAproxy containers..."
docker rm haproxy -f >/dev/null 2>&1 || true
docker run -d --name haproxy --network acada-app -v /opt/docker_config_files/haproxy.config:/usr/local/etc/haproxy/haproxy.cfg:ro -p 9090:80 haproxy:latest
docker ps | grep -i haproxy*
echo "Deploying HAproxy containers done and succefull"

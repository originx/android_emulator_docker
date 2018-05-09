#!/usr/bin/env sh

buildDockerCmd="docker-compose build"
buildDockerParam=""
proxy=$(env |grep https_proxy)

if [ -z "$proxy" ]; then
   echo "host has no proxy settings, so we need probably no proxy settings as well"
else
   proxy=$(echo $proxy |cut -d= -f2) # cut key from line

   protocol=$(echo $proxy | cut -d: -f1)
   port=$(echo $proxy | cut -d: -f3)
   host=$(echo $proxy | cut -d/ -f3 | cut -d: -f1)

   # when squid is used (detect with localhost) we use hostname for Docker
   if [ "$host" == "localhost" ]; then
     host=$(hostname)
   fi

   echo $proxy " --> " $protocol $host $port
   buildDockerParam="--build-arg APROXY_PROTOCOL=$protocol --build-arg APROXY_SERVER=$host --build-arg APROXY_PORT=$port"
fi

buildDockerCmd=$(echo $buildDockerCmd $buildDockerParam)
eval $buildDockerCmd



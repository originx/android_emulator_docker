#!/usr/bin/env sh

BASEDIR=$(dirname "$0")

home=$1 # e.g /home/ci/
emulator=$2 # eg. scripts/emulator.sh or ""
gradleTasks=$3
releaseProfiles=$4

eval "buildDockerCmd='docker-compose -f $BASEDIR/docker-compose.yml build '"
eval "runDockerCmd='docker-compose -f $BASEDIR/docker-compose.yml run -v /dev/kvm:/dev/kvm -v `pwd`:$home android_emulator --privileged bash -c \"$emulator ./gradlew clean $gradleTasks $releaseProfiles --profile --stacktrace\"'"
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

   buildDockerParam="--build-arg APROXY_PROTOCOL=$protocol --build-arg APROXY_SERVER=$host --build-arg APROXY_PORT=$port"
fi

buildDockerCmd=$(echo $buildDockerCmd $buildDockerParam)
echo $buildDockerCmd
eval $buildDockerCmd

echo $runDockerCmd
eval $runDockerCmd



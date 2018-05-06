# Android-emulator

### Version
0.1.0

Initial repo where android emulator with the sdk can be started to run instrumentation or build Android apps
Intended use would be to make a stable image that can be used in CI

## Usage
If you want to run the emulator you can use docker-compose 
```
docker-compose up
```
or manually build the docker image:
```
docker build -t android_tag_emulator . --build-arg APROXY_PROTOCOL=http --build-arg APROXY_SERVER=muc-web-01.loyaltypartner.com --build-arg APROXY_PORT=8080
docker run -d -it -p 5554:5554 --name=AndroidEmulator android_tag_emulator
```
btw ```server.com``` is a synonym

This will build (and run) the Dockerfile which contains basic setup of Ubuntu 16.04 LTS with 27 arm emulator.
Startup.sh script will create, bootup and wait for the emulator to finish booting.

##Enteprise proxies
if you are building or using this image behind a proxy you need to setup your docker client proxy properly
For more info please refer to: https://docs.docker.com/network/proxy/#configure-the-docker-client

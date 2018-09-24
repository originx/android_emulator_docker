# Deprecated 

This dockerimage was a test to see how emulators behave and can be setup for CI purposes across various host systems.
Currently there is no support for nested HAXM virt, so x86 emulators can only be run if your host system is Ubuntu/kvm or if you choose a different backbone for your docker, e.g. virtualbox.
If you have interest in improving this so there is one single docker image usable between systems with nested virt feel free to make a PR.

## Android-emulator

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
docker build -t android_tag_emulator .
docker run -d -it -p 5554:5554 --name=AndroidEmulator android_tag_emulator
```
btw ```server.com``` is a synonym

This will build (and run) the Dockerfile which contains basic setup of Ubuntu 16.04 LTS with 27 arm emulator.
Startup.sh script will create, bootup and wait for the emulator to finish booting.

##Enteprise proxies
if you are building or using this image behind a proxy you need to setup your docker client proxy properly
For more info please refer to: https://docs.docker.com/network/proxy/#configure-the-docker-client

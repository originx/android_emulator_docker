# Android-emulator

### Version
0.0.1

Initial repo where android emulator with the sdk can be started to run instrumentation or build Android apps
Intended use would be to make a stable image that can be used in CI

## Usage
If you want to run the emulator you can use docker-compose 
```
docker-compose up
```
or manually build the docker image:
```
docker build -t android_tag_emulator . --build-arg HTTP_PROXY=http://muc-web-01.server.com:8080 --build-arg HTTPS_PROXY=https://muc-web-01.server.com:8080
docker run -d -it -p 5554:5554 --name=AndroidEmulator android_tag_emulator
```
btw ```server.com``` is a synonym

This will build (and run) the Dockerfile which contains basic setup of Ubuntu 16.04 LTS with 27 arm emulator.
Startup.sh script will create, bootup and wait for the emulator to finish booting.

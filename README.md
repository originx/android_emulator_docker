# Android-emulator

### Version
0.0.1

Initial repo where android emulator with the sdk can be started to run instrumentation or build Android apps
Intended use would be to make a stable image that can be used in CI

## Usage
If you want to run the emulator you can use docker-compose or manually build the docker image:
```
docker-compose up
```

This wil build and run the Dockerfile which contains basic setup of Ubuntu 16.04 LTS with 27 arm emulator.
Startup.sh script will create, bootup and wait for the emulator to finish booting.


#### TODO
-disable animations on emulator for testing
-enable passing emulator image and arch during docker Startup

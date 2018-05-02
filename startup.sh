#!/usr/bin/env sh

if [ -z "$EMULATOR_IMAGE" ]; then
   echo "variable \033[31m\$EMULATOR_IMAGE \033[0mis not set"
fi

if [ -z "$ARCH" ]; then
   echo "variable \033[31m\$ARCH \033[0mis not set"
fi

if [ -z "$EMULATOR_IMAGE" ] || [ -z "$ARCH" ]; then
   echo ""
   exit
fi

# Detect ip and forward ADB ports outside to outside interface
ip=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
socat tcp-listen:5554,bind=$ip,fork tcp:127.0.0.1:5554 &
socat tcp-listen:5555,bind=$ip,fork tcp:127.0.0.1:5555 &

#emulator image and arch is defined in the dockerfile as environment variables.
#possible to make this configurable later on with config file or per CLI args
echo Emulator image: $EMULATOR_IMAGE
echo Architecture: $ARCH

echo create AVD 
echo "no" | avdmanager create avd -f -n emulator_avd --package $EMULATOR_IMAGE --abi $ARCH
echo "no" | emulator -avd emulator_avd -noaudio -no-window -gpu auto -verbose

set +e

bootanim=""
failcounter=0
timeout_in_sec=360

until [[ "$bootanim" =~ "stopped" ]]; do
  bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
  if [[ "$bootanim" =~ "device not found" || "$bootanim" =~ "device offline"
    || "$bootanim" =~ "running" ]]; then
    let "failcounter += 1"
    echo "Waiting for emulator to start"
    if [[ $failcounter -gt timeout_in_sec ]]; then
      echo "Timeout ($timeout_in_sec seconds) reached; failed to start emulator"
      exit 1
    fi
  fi
  sleep 1
done

# Fail proof way to detect emulator ready status
A=$(adb shell getprop sys.boot_completed | tr -d '\r');
sec=0;
while [ "$A" != "1" ]; do
  echo "waiting emulator boot for "$sec" seconds";
  sleep 10;
  sec=$((sec + 10));
  A=$(adb shell getprop sys.boot_completed | tr -d '\r');
done

echo "Emulator is ready"

#Unlock emu - Only works for emulators > Lollipop
if [ $(adb shell dumpsys input_method | grep mInteractive=false | wc -l) -eq 1 ]
then
  adb shell input keyevent 82
else
  echo "the emulator already is unlocked"
fi

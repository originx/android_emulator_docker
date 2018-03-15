
# Description="Android SDK and emulator environment"
# Uses phusion/baseimage as base image.
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.10.0
MAINTAINER morsolic <marioorsolic@gmail.com>
LABEL Version="0.0.1"

# Expose ADB
EXPOSE 5554
EXPOSE 5555
EXPOSE 5900

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install Java.
RUN \
  apt-get update && \
  apt-get install -y openjdk-8-jdk

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install another dependencies
RUN apt-get install git wget unzip net-tools socat gcc-multilib libglu1 -y

#Install Android
ENV ANDROID_HOME /opt/android
RUN wget -O android-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip --show-progress \
&& unzip android-tools.zip -d $ANDROID_HOME && rm android-tools.zip
ENV PATH $PATH:$ANDROID_HOME/tools/bin


#Install Android Tools
RUN yes | sdkmanager --update --verbose
RUN yes | sdkmanager "platform-tools" --verbose
RUN yes | sdkmanager "platforms;android-27" --verbose
RUN yes | sdkmanager "build-tools;27.0.3" --verbose
RUN yes | sdkmanager "system-images;android-23;google_apis;armeabi-v7a" --verbose
RUN yes | sdkmanager "extras;android;m2repository" --verbose
RUN yes | sdkmanager "extras;google;m2repository" --verbose

# Add platform-tools and emulator to path
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANDROID_HOME/emulator

#Install latest android emulator   system images
ENV EMULATOR_IMAGE "system-images;android-23;google_apis;armeabi-v7a"
ENV ARCH "armeabi-v7a"
RUN yes | sdkmanager $EMULATOR_IMAGE --verbose

# Add startup script
ADD startup.sh /startup.sh
RUN chmod +x /startup.sh
ENTRYPOINT ["/startup.sh"]

# Description="Android SDK and emulator environment"
# Uses phusion/baseimage as base image.
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.10.0

## ARG's for build time with default values
ARG APROXY_PROTOCOL=http
ARG APROXY_SERVER
ARG APROXY_PORT=80

# ENV's are for image, probably we need ot later
ENV EPROXY_PROTOCOL=$APROXY_PROTOCOL
ENV EPROXY_SERVER=$APROXY_SERVER
ENV EPROXY_PORT=$APROXY_PORT

MAINTAINER morsolic <marioorsolic@gmail.com>

LABEL Version="0.1.0"

# Expose ADB
EXPOSE 5554
EXPOSE 5555
EXPOSE 5900

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN echo Proxy setting: $APROXY_PROTOCOL $APROXY_SERVER $APROXY_PORT
RUN echo "Acquire::http::Proxy \"http_proxy=$APROXY_PROTOCOL://$APROXY_SERVER:$APROXY_PORT\";" > /etc/apt/apt.conf.d/30proxy

RUN cat /etc/apt/apt.conf.d/30proxy

# Install Java.
RUN \
  apt-get update && \
  apt-get install -y openjdk-8-jdk

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install another dependencies
RUN apt-get install git wget unzip net-tools socat gcc-multilib libglu1 -y

#create empty repo file to supress unneeded warning from sdkmanager on first file creation
RUN mkdir ~/.android && touch ~/.android/repositories.cfg
#Install Android
ENV ANDROID_HOME /opt/android
RUN wget -O android-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip --show-progress \
&& unzip android-tools.zip -d $ANDROID_HOME && rm android-tools.zip
ENV PATH $PATH:$ANDROID_HOME/tools/bin

#Install Android Tools
RUN yes | sdkmanager --update --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy_protocol=$APROXY_PROTOCOL
RUN yes | sdkmanager "platform-tools" --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy_protocol=$APROXY_PROTOCOL
RUN yes | sdkmanager "platforms;android-27" --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy_protocol=$APROXY_PROTOCOL
RUN yes | sdkmanager "build-tools;27.1.1" --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy_protocol=$APROXY_PROTOCOL
RUN yes | sdkmanager "system-images;android-27;google_apis;x86" --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy_protocol=$APROXY_PROTOCOL
RUN yes | sdkmanager "system-images;android-25;google_apis;armeabi-v7a" --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy_protocol=$APROXY_PROTOCOL
RUN yes | sdkmanager "extras;android;m2repository" --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy_protocol=$APROXY_PROTOCOL
RUN yes | sdkmanager "extras;google;m2repository" --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy_protocol=$APROXY_PROTOCOL

# Add platform-tools and emulator to path
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANDROID_HOME/emulator

#Install latest android emulator system images
ENV EMULATOR_IMAGE "system-images;android-25;google_apis;armeabi-v7a"
ENV ARCH "armeabi-v7a"
RUN yes | sdkmanager $EMULATOR_IMAGE --verbose --proxy_host=$APROXY_SERVER --proxy_port=$APROXY_PORT --proxy=$APROXY_PROTOCOL

# Add startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
ENTRYPOINT ["/startup.sh"]

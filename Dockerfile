# Android Studio Webtop - Production Ready Container
# This Dockerfile maintains backward compatibility while pointing to the new devcontainer setup

FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine318

# Install basic dependencies for the legacy setup
RUN apk update && apk add --no-cache \
    android-tools \
    openjdk17 \
    wget \
    chromium \
    qemu \
    qemu-system-x86_64

# Download and install Android Studio
ARG ANDROID_STUDIO_VERSION=2024.1.1.11
RUN wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz -O /tmp/android-studio.tar.gz \
    && mkdir -p /opt/android-studio \
    && tar -xvzf /tmp/android-studio.tar.gz -C /opt/android-studio --strip-components=1 \
    && rm /tmp/android-studio.tar.gz

# Setup environment
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:/opt/android-studio/bin
ENV TITLE="Android Studio - Legacy Setup"
ENV HOME=/config

# Configure auto-start
RUN mkdir -p /defaults /config \
    && echo "/opt/android-studio/bin/studio.sh" > /defaults/autostart

# Configure Openbox to remove window decorations
RUN mkdir -p /config/.config/openbox \
    && echo '<?xml version="1.0" encoding="UTF-8"?> \
<openbox_config xmlns="http://openbox.org/3.4/rc" xmlns:xi="http://www.w3.org/2001/XInclude"> \
  <applications> \
    <application type="normal" class="jetbrains-studio"> \
      <decor>no</decor> \
      <maximized>yes</maximized> \
    </application> \
  </applications> \
</openbox_config>' > /config/.config/openbox/rc.xml

# Add notice about the new devcontainer setup
RUN echo '#!/bin/sh\n\
echo ""\n\
echo "================================================================="\n\
echo "NOTICE: This is the legacy Android Studio Webtop setup."\n\
echo ""\n\
echo "For a production-ready environment with full Android SDK,"\n\
echo "emulator support, and development tools, please use:"\n\
echo ""\n\
echo "  cd .devcontainer"\n\
echo "  docker-compose up -d"\n\
echo ""\n\
echo "Or open this repository in VS Code with Dev Containers extension."\n\
echo "================================================================="\n\
echo ""\n\
sleep 5' > /defaults/startup-notice.sh \
    && chmod +x /defaults/startup-notice.sh \
    && echo "/defaults/startup-notice.sh" >> /defaults/autostart

# Enable nested virtualization
RUN echo "options kvm_intel nested=1" > /etc/modprobe.d/kvm_intel.conf

# Initialize the container
CMD ["/init"]

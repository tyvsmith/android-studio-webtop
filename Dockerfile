FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine317

RUN apk update
RUN apk add --no-cache android-tools \
         openjdk17 

RUN wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.1.1.11/android-studio-2024.1.1.11-linux.tar.gz -O /tmp/android-studio.tar.gz \
    && mkdir -p /opt/android-studio \
    && tar -xvzf /tmp/android-studio.tar.gz -C /opt/android-studio --strip-components=1 \
    && rm /tmp/android-studio.tar.gz

RUN mkdir -p /defaults
# Set up autostart for Android Studio
RUN echo "/opt/android-studio/bin/studio.sh" > /defaults/autostart
RUN mkdir -p /config

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV TITLE="Android Studio"
ENV HOME=/config

# Configure Openbox to remove window decorations for Android Studio
RUN mkdir -p /config/.config/openbox \
    && echo '<?xml version="1.0" encoding="UTF-8"?> \
<openbox_config> \
  <applications> \
    <application  type="normal" class="jetbrains-studio"> \
      <decor>no</decor> \
      <fullscreen>yes</fullscreen> \
    </application> \
  </applications> \
</openbox_config>' > /config/.config/openbox/rc.xml


CMD ["/init"]


#TODO: security setting for opening link, nested virtualization for emulator
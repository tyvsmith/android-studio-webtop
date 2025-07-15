# Multi-stage build for optimized Android development environment
FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntu-22.04 as base

# Build arguments
ARG ANDROID_STUDIO_VERSION=2024.1.1.11
ARG ANDROID_SDK_VERSION=34
ARG BUILD_TOOLS_VERSION=34.0.0
ARG GRADLE_VERSION=8.4
ARG CMDLINE_TOOLS_VERSION=11076708

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    GRADLE_HOME=/opt/gradle \
    GRADLE_USER_HOME=/home/developer/.gradle \
    PATH=/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/emulator:/opt/android-studio/bin:/opt/gradle/bin:$PATH \
    DISPLAY=:1 \
    VNC_RESOLUTION=1920x1080 \
    TITLE="Android Studio Development Environment"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Development tools
    build-essential \
    git \
    git-lfs \
    curl \
    wget \
    unzip \
    zip \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    # Java and build tools
    openjdk-11-jdk \
    openjdk-17-jdk \
    maven \
    ant \
    # Android dependencies
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    lib32z1 \
    libbz2-1.0:i386 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxrandr2 \
    libxcursor1 \
    libxinerama1 \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglu1-mesa \
    libgtk-3-0 \
    libpulse0 \
    # KVM and hardware acceleration
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    cpu-checker \
    # Development utilities
    vim \
    nano \
    htop \
    tmux \
    screen \
    jq \
    yq \
    tree \
    ncdu \
    ripgrep \
    fd-find \
    bat \
    fzf \
    # Network tools
    net-tools \
    iputils-ping \
    dnsutils \
    traceroute \
    tcpdump \
    nmap \
    netcat \
    # Python for scripts
    python3 \
    python3-pip \
    python3-venv \
    # Node.js for React Native
    nodejs \
    npm \
    # Database clients
    sqlite3 \
    postgresql-client \
    mysql-client \
    # Code quality tools
    shellcheck \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir \
    httpie \
    docker-compose \
    pre-commit \
    black \
    flake8 \
    pylint \
    mypy

# Create developer user
RUN groupadd -g 1000 developer && \
    useradd -m -u 1000 -g developer -G sudo,kvm,libvirt,video,render,audio developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/developer/.config /home/developer/.cache /home/developer/.local

# Install Android Studio
RUN wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz -O /tmp/android-studio.tar.gz && \
    mkdir -p /opt/android-studio && \
    tar -xzf /tmp/android-studio.tar.gz -C /opt/android-studio --strip-components=1 && \
    rm /tmp/android-studio.tar.gz && \
    chmod +x /opt/android-studio/bin/studio.sh && \
    ln -s /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio

# Install Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Accept Android SDK licenses and install SDK components
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-${ANDROID_SDK_VERSION}" \
    "build-tools;${BUILD_TOOLS_VERSION}" \
    "system-images;android-${ANDROID_SDK_VERSION};google_apis;x86_64" \
    "emulator" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "cmake;3.22.1" \
    "ndk;25.2.9519653"

# Install Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt && \
    mv /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    rm /tmp/gradle.zip

# Install additional development tools
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn react-native-cli expo-cli eas-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install VS Code CLI for remote development
RUN curl -fsSL https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64 | tar -xz -C /usr/local/bin

# Configure Openbox window manager
RUN mkdir -p /etc/xdg/openbox && \
    echo '<?xml version="1.0" encoding="UTF-8"?> \
<openbox_config xmlns="http://openbox.org/3.4/rc"> \
  <applications> \
    <application type="normal" class="jetbrains-studio"> \
      <decor>no</decor> \
      <maximized>yes</maximized> \
      <focus>yes</focus> \
    </application> \
  </applications> \
  <keyboard> \
    <keybind key="A-Tab"> \
      <action name="NextWindow"/> \
    </keybind> \
    <keybind key="A-F4"> \
      <action name="Close"/> \
    </keybind> \
    <keybind key="W-r"> \
      <action name="Execute"> \
        <command>rofi -show run</command> \
      </action> \
    </keybind> \
  </keyboard> \
</openbox_config>' > /etc/xdg/openbox/rc.xml

# Setup KasmVNC configuration
RUN mkdir -p /defaults && \
    echo "#!/bin/bash\n\
export DISPLAY=:1\n\
export HOME=/home/developer\n\
cd /workspace\n\
/opt/android-studio/bin/studio.sh" > /defaults/autostart && \
    chmod +x /defaults/autostart

# Copy configuration files
COPY --chown=developer:developer config/android-studio /home/developer/.config/Google/AndroidStudio
COPY --chown=developer:developer config/gradle /home/developer/.gradle
COPY --chown=developer:developer scripts /workspace/scripts

# Set up Android Studio initial configuration
RUN mkdir -p /home/developer/.config/Google/AndroidStudio && \
    echo '<?xml version="1.0" encoding="UTF-8"?> \
<application> \
  <component name="GeneralSettings"> \
    <option name="confirmExit" value="false" /> \
    <option name="showTipsOnStartup" value="false" /> \
    <option name="autoSaveFiles" value="true" /> \
  </component> \
  <component name="PropertiesComponent"> \
    <property name="android.sdk.path" value="/opt/android-sdk" /> \
  </component> \
</application>' > /home/developer/.config/Google/AndroidStudio/options/ide.general.xml

# Create workspace directory
RUN mkdir -p /workspace && chown -R developer:developer /workspace

# Switch to developer user
USER developer
WORKDIR /workspace

# Pre-download common Gradle distributions
RUN gradle wrapper --gradle-version=${GRADLE_VERSION} --distribution-type=all && \
    rm -rf /workspace/gradle /workspace/gradlew /workspace/gradlew.bat

# Switch back to root for runtime
USER root

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Entry point
ENTRYPOINT ["/init"]
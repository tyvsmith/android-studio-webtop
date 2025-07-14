# Android Development Environment - Setup Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Detailed Setup](#detailed-setup)
4. [Configuration Options](#configuration-options)
5. [Troubleshooting](#troubleshooting)
6. [Advanced Usage](#advanced-usage)

## Prerequisites

### System Requirements
- **CPU**: 4+ cores (8+ recommended)
- **RAM**: 8GB minimum (16GB recommended)
- **Storage**: 50GB+ free space
- **OS**: Linux, macOS, or Windows with WSL2
- **Virtualization**: KVM support (for hardware acceleration)

### Software Requirements
- Docker Desktop or Docker Engine (20.10+)
- Docker Compose (2.0+)
- VS Code with Dev Containers extension (recommended)
- Git

### Network Requirements
- Stable internet connection for downloading SDK components
- Access to Docker Hub and GitHub Container Registry
- Ports 3000, 5037, 5554-5555 available

## Quick Start

### Option 1: Using VS Code Dev Containers (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/tyvsmith/android-studio-webtop.git
   cd android-studio-webtop
   ```

2. **Open in VS Code**
   ```bash
   code .
   ```

3. **Reopen in Container**
   - Press `F1` or `Cmd/Ctrl + Shift + P`
   - Select "Dev Containers: Reopen in Container"
   - Wait for the container to build (first time takes 15-30 minutes)

4. **Access Android Studio**
   - Open browser to http://localhost:3000
   - Or run `android-studio` in the VS Code terminal

### Option 2: Using Docker Compose

1. **Clone and navigate to the repository**
   ```bash
   git clone https://github.com/tyvsmith/android-studio-webtop.git
   cd android-studio-webtop/.devcontainer
   ```

2. **Start the container**
   ```bash
   docker-compose up -d
   ```

3. **Access the environment**
   - Web UI: http://localhost:3000
   - VNC: localhost:5900 (password: `android`)
   - SSH into container: `docker exec -it android-studio-dev bash`

### Option 3: Using Docker CLI

```bash
# Build the image
docker build -t android-dev .devcontainer/

# Run the container
docker run -d \
  --name android-studio \
  -p 3000:3000 \
  -p 5037:5037 \
  -p 5554:5554 \
  -p 5555:5555 \
  --device /dev/kvm \
  --device /dev/dri \
  -v $(pwd):/workspace \
  android-dev
```

## Detailed Setup

### 1. Initial Configuration

After the container starts, the post-create script will:
- Set up Android SDK components
- Configure Gradle and Maven
- Create project directories
- Install VS Code extensions
- Set up Git configuration

### 2. Android SDK Setup

The environment includes:
- Android SDK Platform 34 (Android 14)
- Build Tools 34.0.0
- Platform Tools (ADB, Fastboot)
- Android Emulator
- System Images for x86_64
- CMake and NDK

To install additional SDK components:
```bash
sdkmanager "platforms;android-33"
sdkmanager "build-tools;33.0.2"
sdkmanager "system-images;android-33;google_apis;x86_64"
```

### 3. Creating Your First Project

1. **Using Android Studio**
   - Open Android Studio from the web interface
   - Click "New Project"
   - Select a template (e.g., "Empty Activity")
   - Configure project settings
   - Click "Finish"

2. **Using Command Line**
   ```bash
   cd ~/AndroidStudioProjects
   # Create a new project using Android Studio's command line tools
   ```

### 4. Connecting Devices

#### Physical Device
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device to host machine
4. In container terminal: `adb devices`

#### Emulator
1. Create an AVD:
   ```bash
   avdmanager create avd -n "Pixel_6" -k "system-images;android-34;google_apis;x86_64"
   ```
2. Start emulator:
   ```bash
   emulator -avd Pixel_6
   ```

### 5. Running Your App

1. **From Android Studio**
   - Click the "Run" button (green triangle)
   - Select target device
   - Wait for build and deployment

2. **From Command Line**
   ```bash
   ./gradlew assembleDebug
   ./gradlew installDebug
   adb shell am start -n com.example.app/.MainActivity
   ```

## Configuration Options

### Environment Variables

You can customize the environment by setting these variables in `docker-compose.yml`:

```yaml
environment:
  - VNC_RESOLUTION=1920x1080  # Change display resolution
  - VNC_PW=yourpassword       # Change VNC password
  - ENABLE_HARDWARE_ACCELERATION=false  # Disable if no KVM
  - GRADLE_OPTS=-Xmx4096m     # Adjust Gradle memory
```

### Persistent Storage

Data is persisted in Docker volumes:
- `android-sdk`: SDK installations
- `gradle-cache`: Build cache
- `maven-cache`: Maven dependencies
- `android-home`: AVDs and user data

### Resource Limits

Adjust in `docker-compose.yml`:
```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 8G
    reservations:
      cpus: '2'
      memory: 4G
```

## Troubleshooting

### Common Issues

#### 1. KVM Not Available
**Error**: `/dev/kvm` not found
**Solution**: 
- Enable virtualization in BIOS
- Install KVM: `sudo apt install qemu-kvm`
- Add user to kvm group: `sudo usermod -aG kvm $USER`

#### 2. Out of Memory
**Error**: Gradle build fails with heap space error
**Solution**:
- Increase Docker memory allocation
- Adjust Gradle memory: `GRADLE_OPTS=-Xmx6g`

#### 3. Slow Performance
**Solutions**:
- Enable hardware acceleration
- Increase CPU/memory allocation
- Use x86_64 system images
- Enable Gradle build cache

#### 4. Cannot Connect to Device
**Error**: `adb devices` shows no devices
**Solutions**:
- Restart ADB: `adb kill-server && adb start-server`
- Check USB debugging is enabled
- Try wireless ADB: `adb tcpip 5555`

### Logs and Debugging

View logs:
```bash
# Container logs
docker logs android-studio-dev

# Android Studio logs
tail -f ~/workspace/.android/studio.log

# ADB logs
adb logcat
```

## Advanced Usage

### Custom Project Templates

Create custom templates in:
```
~/AndroidStudioProjects/templates/
```

### Gradle Configuration

Global Gradle settings in:
```
~/.gradle/gradle.properties
~/.gradle/init.gradle
```

### Pre-commit Hooks

Set up code quality checks:
```bash
cd your-project
pre-commit install
```

### CI/CD Integration

Example GitHub Actions workflow:
```yaml
name: Android CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/yourusername/android-dev:latest
    steps:
      - uses: actions/checkout@v2
      - run: ./gradlew build
      - run: ./gradlew test
```

### Remote Development

Access from other machines:
1. Use SSH tunneling: `ssh -L 3000:localhost:3000 user@host`
2. Or expose ports carefully with proper authentication

## Next Steps

- Read the [Best Practices Guide](BEST_PRACTICES.md)
- Check out [Sample Projects](../samples/)
- Join our [Community Discord](#)
- Report issues on [GitHub](https://github.com/tyvsmith/android-studio-webtop/issues)
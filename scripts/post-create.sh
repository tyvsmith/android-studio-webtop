#!/bin/bash
set -euo pipefail

echo "🚀 Running post-create setup for Android Development Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Create necessary directories
print_status "Creating directory structure..."
mkdir -p ~/AndroidStudioProjects
mkdir -p ~/.android/avd
mkdir -p ~/.gradle
mkdir -p ~/.m2
mkdir -p ~/.cache
mkdir -p ~/.config/Google/AndroidStudio
mkdir -p ~/workspace/android-apps

# Set up Git configuration
print_status "Configuring Git..."
if [ -z "$(git config --global user.email)" ]; then
    git config --global user.email "developer@android-dev.local"
    git config --global user.name "Android Developer"
fi

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global core.editor "code --wait"

# Configure Git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Set up Android SDK
print_status "Verifying Android SDK installation..."
if [ -d "$ANDROID_HOME" ]; then
    # Update SDK components
    print_status "Updating Android SDK components..."
    yes | sdkmanager --update || true
    
    # Install additional SDK packages
    print_status "Installing additional SDK packages..."
    yes | sdkmanager \
        "platforms;android-33" \
        "platforms;android-32" \
        "platforms;android-31" \
        "build-tools;33.0.2" \
        "build-tools;32.0.0" \
        "sources;android-34" \
        "sources;android-33" || true
else
    print_error "Android SDK not found at $ANDROID_HOME"
fi

# Configure Gradle
print_status "Configuring Gradle..."
cat > ~/.gradle/gradle.properties << EOF
# Gradle performance improvements
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true
org.gradle.caching=true
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8

# Android build optimizations
android.useAndroidX=true
android.enableJetifier=true
android.enableR8.fullMode=true
android.nonTransitiveRClass=true
android.nonFinalResIds=true

# Kotlin
kotlin.code.style=official
kotlin.incremental=true
kotlin.caching.enabled=true
kotlin.incremental.java=true
EOF

# Set up Maven settings
print_status "Configuring Maven..."
mkdir -p ~/.m2
cat > ~/.m2/settings.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              http://maven.apache.org/xsd/settings-1.0.0.xsd">
    <localRepository>/home/developer/.m2/repository</localRepository>
    <interactiveMode>true</interactiveMode>
    <usePluginRegistry>false</usePluginRegistry>
    <offline>false</offline>
</settings>
EOF

# Install VS Code extensions if code-server is available
if command -v code &> /dev/null; then
    print_status "Installing VS Code extensions..."
    code --install-extension vscjava.vscode-java-pack || true
    code --install-extension fwcd.kotlin || true
    code --install-extension vscjava.vscode-gradle || true
fi

# Create sample Android project structure
print_status "Creating sample project structure..."
mkdir -p ~/workspace/android-apps/sample-app
cat > ~/workspace/android-apps/sample-app/README.md << EOF
# Sample Android App

This is a sample directory structure for Android applications.

## Getting Started

1. Open Android Studio
2. Click on "New Project" or "Open Existing Project"
3. Select your project template
4. Start developing!

## Useful Commands

- Build: \`./gradlew build\`
- Run tests: \`./gradlew test\`
- Install on device: \`./gradlew installDebug\`
- Clean: \`./gradlew clean\`
EOF

# Set up Android emulator
print_status "Checking KVM support..."
if [ -w /dev/kvm ]; then
    print_status "KVM is available for hardware acceleration"
    
    # Create a default AVD if none exists
    if [ -z "$(avdmanager list avd | grep 'Name:')" ]; then
        print_status "Creating default Android Virtual Device..."
        echo "no" | avdmanager create avd \
            -n "Pixel_6_API_34" \
            -k "system-images;android-34;google_apis;x86_64" \
            -d "pixel_6" || print_warning "Failed to create AVD. You can create one manually in Android Studio."
    fi
else
    print_warning "KVM not available. Emulator will run without hardware acceleration."
fi

# Set up shell aliases
print_status "Setting up shell aliases..."
cat >> ~/.bashrc << 'EOF'

# Android development aliases
alias adb-devices='adb devices'
alias adb-wifi='adb tcpip 5555'
alias adb-connect='adb connect'
alias adb-logcat='adb logcat'
alias gradle-clean='./gradlew clean'
alias gradle-build='./gradlew build'
alias gradle-install='./gradlew installDebug'
alias emulator-list='emulator -list-avds'
alias studio='android-studio'

# Utility functions
adb-screenshot() {
    adb shell screencap -p /sdcard/screenshot.png
    adb pull /sdcard/screenshot.png
    adb shell rm /sdcard/screenshot.png
    echo "Screenshot saved as screenshot.png"
}

adb-record() {
    echo "Recording... Press Ctrl+C to stop"
    adb shell screenrecord /sdcard/recording.mp4
    adb pull /sdcard/recording.mp4
    adb shell rm /sdcard/recording.mp4
    echo "Recording saved as recording.mp4"
}

# Export Android environment variables
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
EOF

# Set up Zsh if available
if [ -f ~/.zshrc ]; then
    print_status "Configuring Zsh..."
    cat >> ~/.zshrc << 'EOF'

# Android development aliases
alias adb-devices='adb devices'
alias adb-wifi='adb tcpip 5555'
alias adb-connect='adb connect'
alias adb-logcat='adb logcat'
alias gradle-clean='./gradlew clean'
alias gradle-build='./gradlew build'
alias gradle-install='./gradlew installDebug'
alias emulator-list='emulator -list-avds'
alias studio='android-studio'

# Export Android environment variables
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
EOF
fi

# Create desktop shortcuts
print_status "Creating desktop shortcuts..."
mkdir -p ~/Desktop
cat > ~/Desktop/android-studio.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Icon=/opt/android-studio/bin/studio.png
Exec=/opt/android-studio/bin/studio.sh
Comment=Android Studio IDE
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-studio
EOF
chmod +x ~/Desktop/android-studio.desktop

# Download and setup common Android libraries
print_status "Setting up common Android libraries cache..."
mkdir -p ~/.m2/repository
mkdir -p ~/.gradle/caches/modules-2/files-2.1

# Create a welcome message
cat > ~/WELCOME.md << EOF
# Welcome to Android Development Environment! 🎉

Your Android development environment is ready to use!

## Quick Start

1. **Open Android Studio**: Click the desktop icon or run \`android-studio\` in terminal
2. **Access via Web**: Navigate to http://localhost:3000
3. **Connect a device**: Use \`adb devices\` to list connected devices

## Important Paths

- **Android SDK**: $ANDROID_HOME
- **Android Studio**: /opt/android-studio
- **Projects**: ~/AndroidStudioProjects
- **Gradle Cache**: ~/.gradle

## Useful Commands

- \`adb-devices\`: List connected devices
- \`emulator-list\`: List available emulators
- \`gradle-build\`: Build current project
- \`studio\`: Launch Android Studio

## Resources

- [Android Developer Documentation](https://developer.android.com)
- [Android Studio User Guide](https://developer.android.com/studio/intro)
- [Kotlin Documentation](https://kotlinlang.org/docs/home.html)

Happy coding! 🚀
EOF

print_status "Post-create setup completed successfully! 🎉"
echo ""
echo "You can now:"
echo "  - Open Android Studio from the desktop icon"
echo "  - Access the web interface at http://localhost:3000"
echo "  - Start developing Android applications!"
echo ""
echo "Run 'cat ~/WELCOME.md' for more information."
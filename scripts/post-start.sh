#!/bin/bash
set -euo pipefail

echo "🔧 Running post-start setup..."

# Start ADB server
echo "Starting ADB server..."
adb start-server || true

# Check for connected devices
adb devices

# Start any background services
if command -v redis-server &> /dev/null; then
    echo "Starting Redis server..."
    redis-server --daemonize yes || true
fi

# Ensure proper permissions
sudo chown -R developer:developer /home/developer/.android || true
sudo chown -R developer:developer /home/developer/.gradle || true
sudo chown -R developer:developer /workspace || true

# Check hardware acceleration
if [ -w /dev/kvm ]; then
    echo "✅ KVM hardware acceleration is available"
else
    echo "⚠️  KVM not available - emulator will run in software mode"
fi

# Display system information
echo ""
echo "System Information:"
echo "==================="
echo "CPU Cores: $(nproc)"
echo "Memory: $(free -h | grep '^Mem:' | awk '{print $2}')"
echo "Disk Space: $(df -h /workspace | tail -1 | awk '{print $4}' | sed 's/G/ GB/')"
echo "Java Version: $(java -version 2>&1 | head -1)"
echo "Gradle Version: $(gradle --version | grep '^Gradle' | awk '{print $2}')"
echo "Android SDK: $ANDROID_HOME"
echo ""

echo "✅ Post-start setup completed!"
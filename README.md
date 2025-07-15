# Android Studio Webtop - Production Ready DevContainer

A comprehensive, production-ready Docker development environment for Android developers, featuring Android Studio, SDK management, emulator support, and modern development tools accessible through a web browser.

## 🚀 Features

### Core Features
- **Android Studio**: Latest version with web-based access via KasmVNC
- **Complete Android SDK**: Pre-installed with common platforms and build tools
- **Hardware Acceleration**: KVM support for fast emulator performance
- **VS Code Integration**: Full Dev Containers support with extensions
- **Modern Development Stack**: Kotlin, Java 11/17, Gradle, Maven
- **Web-based Access**: Access your development environment from any browser

### Developer Tools
- **Build Systems**: Gradle 8.4+, Maven, Bazel support
- **Version Control**: Git, Git LFS, GitHub CLI pre-configured
- **Testing Frameworks**: JUnit, Espresso, Robolectric ready
- **Code Quality**: Lint, SonarLint, pre-commit hooks
- **CI/CD Ready**: Optimized for GitHub Actions, GitLab CI
- **Package Managers**: npm, yarn for React Native development

### Performance & Optimization
- **Persistent Caches**: Gradle, Maven, and SDK caches
- **Multi-stage Builds**: Optimized Docker layers
- **Resource Management**: Configurable CPU/memory limits
- **Build Optimization**: Parallel builds, daemon mode enabled

## 📋 Prerequisites

- Docker Desktop or Docker Engine (20.10+)
- 8GB RAM minimum (16GB recommended)
- 50GB+ free disk space
- KVM support for hardware acceleration (Linux)

## 🏃 Quick Start

### Option 1: VS Code Dev Containers (Recommended)

```bash
# Clone the repository
git clone https://github.com/tyvsmith/android-studio-webtop.git
cd android-studio-webtop

# Open in VS Code
code .

# Use Command Palette (F1): "Dev Containers: Reopen in Container"
```

### Option 2: Docker Compose

```bash
# Navigate to devcontainer directory
cd android-studio-webtop/.devcontainer

# Start the environment
docker-compose up -d

# Access at http://localhost:3000
```

### Option 3: Legacy Setup

For the original minimal setup:
```bash
docker build -t android-studio-webtop .
docker run --rm -it -p 3000:3000 android-studio-webtop
```

## 🌐 Accessing the Environment

| Service | URL/Port | Description |
|---------|----------|-------------|
| Web UI | http://localhost:3000 | Main web interface |
| VNC | localhost:5900 | Direct VNC access |
| ADB | localhost:5037 | Android Debug Bridge |
| Emulator | localhost:5554-5555 | Android Emulator ports |

Default VNC password: `android`

## 📚 Documentation

- [**Setup Guide**](docs/SETUP_GUIDE.md) - Detailed installation and configuration
- [**Best Practices**](docs/BEST_PRACTICES.md) - Android development best practices
- [**Troubleshooting**](docs/SETUP_GUIDE.md#troubleshooting) - Common issues and solutions

## 🛠️ Configuration

### Environment Variables

```yaml
VNC_RESOLUTION: "1920x1080"     # Display resolution
ENABLE_HARDWARE_ACCELERATION: "true"  # KVM acceleration
GRADLE_OPTS: "-Xmx4096m"        # Gradle memory settings
```

### Persistent Data

All development data is persisted in Docker volumes:
- Android SDK installations
- Gradle and Maven caches
- Project files and configurations
- Android Virtual Devices (AVDs)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 🐛 Known Issues

- Hardware acceleration requires KVM on Linux hosts
- Windows users need WSL2 for optimal performance
- macOS users may experience slower emulator performance

## 📄 License

This project is licensed under the GPL v3 License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- [LinuxServer.io](https://www.linuxserver.io/) for the excellent KasmVNC base image
- [Google](https://developer.android.com/) for Android Studio and SDK
- [JetBrains](https://www.jetbrains.com/) for the IntelliJ platform
- The Android development community for feedback and contributions

## 🔗 Links

- [Project Homepage](https://github.com/tyvsmith/android-studio-webtop)
- [Issue Tracker](https://github.com/tyvsmith/android-studio-webtop/issues)
- [Docker Hub](https://hub.docker.com/r/tyvsmith/android-studio-webtop)

---

**Note**: This project has evolved from a simple Android Studio container to a comprehensive development environment. The original simple setup is still available for basic use cases.

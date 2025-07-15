#!/bin/bash
set -euo pipefail

# Display welcome message
cat << 'EOF'

    ___              __           _     __   _____ __            ___     
   /   |  ____  ____/ /________  (_)___/ /  / ___// /___  ______/ (_)___ 
  / /| | / __ \/ __  / ___/ __ \/ / __  /   \__ \/ __/ / / / __  / / __ \
 / ___ |/ / / / /_/ / /  / /_/ / / /_/ /   ___/ / /_/ /_/ / /_/ / / /_/ /
/_/  |_/_/ /_/\__,_/_/   \____/_/\__,_/   /____/\__/\__,_/\__,_/_/\____/ 
                                                                          
EOF

echo "Welcome to Android Development Environment! 🚀"
echo ""
echo "Quick Commands:"
echo "  • android-studio    - Launch Android Studio"
echo "  • adb devices       - List connected devices"
echo "  • emulator -list-avds - List available emulators"
echo "  • code .            - Open VS Code in current directory"
echo ""
echo "Web Interface: http://localhost:3000"
echo ""
echo "Type 'cat ~/WELCOME.md' for detailed documentation."
echo ""

# Source the bashrc to ensure aliases are available
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Check if this is the first attach
if [ ! -f ~/.first_attach_done ]; then
    echo "First time setup detected. Running initial configuration..."
    touch ~/.first_attach_done
    
    # Offer to create a sample project
    echo ""
    read -p "Would you like to create a sample Android project? (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd ~/AndroidStudioProjects
        echo "Creating sample project..."
        # This would normally use Android Studio's command line tools
        echo "Please use Android Studio's 'New Project' wizard for the best experience."
    fi
fi

# Show current directory
echo ""
echo "Current directory: $(pwd)"
echo ""
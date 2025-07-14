#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ASCII Art Banner
cat << "EOF"
    ___              __           _     __   _____ __            ___     
   /   |  ____  ____/ /________  (_)___/ /  / ___// /___  ______/ (_)___ 
  / /| | / __ \/ __  / ___/ __ \/ / __  /   \__ \/ __/ / / / __  / / __ \
 / ___ |/ / / / /_/ / /  / /_/ / / /_/ /   ___/ / /_/ /_/ / /_/ / / /_/ /
/_/  |_/_/ /_/\__,_/_/   \____/_/\__,_/   /____/\__/\__,_/\__,_/_/\____/ 
                                                                          
                    Quick Start Setup Script
EOF

echo ""
echo -e "${BLUE}Welcome to Android Studio Webtop Setup!${NC}"
echo ""

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

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    # Check Docker
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
        print_status "Docker installed (version: $DOCKER_VERSION)"
    else
        print_error "Docker not found. Please install Docker first."
        echo "Visit: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    # Check Docker Compose
    if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
        print_status "Docker Compose installed"
    else
        print_error "Docker Compose not found. Please install Docker Compose."
        echo "Visit: https://docs.docker.com/compose/install/"
        exit 1
    fi
    
    # Check available disk space
    AVAILABLE_SPACE=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$AVAILABLE_SPACE" -lt 50 ]; then
        print_warning "Low disk space: ${AVAILABLE_SPACE}GB available (50GB recommended)"
    else
        print_status "Sufficient disk space: ${AVAILABLE_SPACE}GB available"
    fi
    
    # Check KVM (Linux only)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -e /dev/kvm ]; then
            print_status "KVM hardware acceleration available"
        else
            print_warning "KVM not available - emulator will run without hardware acceleration"
            echo "    To enable KVM:"
            echo "    1. Enable virtualization in BIOS"
            echo "    2. Install KVM: sudo apt install qemu-kvm"
            echo "    3. Add user to kvm group: sudo usermod -aG kvm \$USER"
        fi
    fi
}

# Setup selection
setup_type() {
    echo ""
    print_info "Select setup type:"
    echo "  1) Production DevContainer (Recommended) - Full Android development environment"
    echo "  2) Legacy Setup - Minimal Android Studio container"
    echo "  3) Exit"
    echo ""
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            setup_devcontainer
            ;;
        2)
            setup_legacy
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please try again."
            setup_type
            ;;
    esac
}

# Setup DevContainer
setup_devcontainer() {
    print_info "Setting up Production DevContainer..."
    
    cd .devcontainer
    
    # Check if we should build or pull
    echo ""
    read -p "Build locally or pull from registry? (build/pull) [build]: " build_choice
    build_choice=${build_choice:-build}
    
    if [ "$build_choice" = "pull" ]; then
        print_info "Pulling image from registry..."
        docker-compose pull
    else
        print_info "Building DevContainer (this may take 15-30 minutes on first build)..."
        docker-compose build
    fi
    
    print_info "Starting container..."
    docker-compose up -d
    
    # Wait for container to be ready
    print_info "Waiting for container to be ready..."
    sleep 10
    
    # Check if container is running
    if docker ps | grep -q android-studio-dev; then
        print_status "Container started successfully!"
        
        echo ""
        print_status "Android Studio DevContainer is ready!"
        echo ""
        echo -e "${GREEN}Access your environment:${NC}"
        echo "  • Web UI: http://localhost:3000"
        echo "  • VNC: localhost:5900 (password: android)"
        echo "  • Terminal: docker exec -it android-studio-dev bash"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo "  1. Open http://localhost:3000 in your browser"
        echo "  2. Android Studio will start automatically"
        echo "  3. Create or open a project"
        echo ""
        echo "For detailed documentation, see: docs/SETUP_GUIDE.md"
    else
        print_error "Container failed to start. Check logs with: docker-compose logs"
        exit 1
    fi
}

# Setup Legacy
setup_legacy() {
    print_info "Setting up Legacy container..."
    
    print_info "Building Docker image..."
    docker build -t android-studio-webtop .
    
    print_info "Starting container..."
    docker run -d \
        --name android-studio-legacy \
        -p 3000:3000 \
        android-studio-webtop
    
    if docker ps | grep -q android-studio-legacy; then
        print_status "Legacy container started successfully!"
        echo ""
        echo "Access at: http://localhost:3000"
        echo ""
        print_warning "Note: This is the minimal setup. For full features, use the DevContainer setup."
    else
        print_error "Container failed to start"
        exit 1
    fi
}

# Cleanup function
cleanup() {
    echo ""
    print_info "Cleanup options:"
    echo "  1) Stop containers"
    echo "  2) Stop and remove containers"
    echo "  3) Full cleanup (remove containers, images, and volumes)"
    echo "  4) Cancel"
    echo ""
    read -p "Enter your choice (1-4): " cleanup_choice
    
    case $cleanup_choice in
        1)
            print_info "Stopping containers..."
            cd .devcontainer && docker-compose stop
            docker stop android-studio-legacy 2>/dev/null || true
            print_status "Containers stopped"
            ;;
        2)
            print_info "Stopping and removing containers..."
            cd .devcontainer && docker-compose down
            docker rm -f android-studio-legacy 2>/dev/null || true
            print_status "Containers removed"
            ;;
        3)
            print_warning "This will remove all data including SDK downloads and caches!"
            read -p "Are you sure? (y/N): " confirm
            if [ "$confirm" = "y" ]; then
                print_info "Performing full cleanup..."
                cd .devcontainer && docker-compose down -v --rmi all
                docker rm -f android-studio-legacy 2>/dev/null || true
                docker rmi android-studio-webtop 2>/dev/null || true
                print_status "Full cleanup completed"
            fi
            ;;
        4)
            echo "Cleanup cancelled"
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
}

# Main menu
main_menu() {
    echo ""
    print_info "What would you like to do?"
    echo "  1) Setup new environment"
    echo "  2) Check status"
    echo "  3) View logs"
    echo "  4) Cleanup"
    echo "  5) Exit"
    echo ""
    read -p "Enter your choice (1-5): " main_choice
    
    case $main_choice in
        1)
            check_prerequisites
            setup_type
            ;;
        2)
            print_info "Checking container status..."
            docker ps --filter "name=android-studio" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
            ;;
        3)
            print_info "Select container to view logs:"
            echo "  1) DevContainer"
            echo "  2) Legacy"
            read -p "Choice (1-2): " log_choice
            case $log_choice in
                1) cd .devcontainer && docker-compose logs -f ;;
                2) docker logs -f android-studio-legacy ;;
            esac
            ;;
        4)
            cleanup
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            main_menu
            ;;
    esac
}

# Script entry point
if [ $# -eq 0 ]; then
    main_menu
else
    case "$1" in
        --check)
            check_prerequisites
            ;;
        --setup)
            check_prerequisites
            setup_devcontainer
            ;;
        --cleanup)
            cleanup
            ;;
        --help)
            echo "Usage: $0 [OPTION]"
            echo "Options:"
            echo "  --check     Check prerequisites only"
            echo "  --setup     Quick setup (DevContainer)"
            echo "  --cleanup   Cleanup containers and images"
            echo "  --help      Show this help message"
            echo ""
            echo "Run without options for interactive menu"
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Run '$0 --help' for usage information"
            exit 1
            ;;
    esac
fi
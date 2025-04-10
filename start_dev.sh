#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Property App Development Server ===${NC}\n"

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo -e "${RED}Error: PHP is not installed${NC}"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed${NC}"
    exit 1
fi

# Function to check if a port is in use
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        return 0
    else
        return 1
    fi
}

# Function to kill process using a port
kill_port() {
    pid=$(lsof -Pi :$1 -sTCP:LISTEN -t)
    if [ ! -z "$pid" ]; then
        echo -e "${YELLOW}Port $1 is in use. Killing process...${NC}"
        kill $pid
        sleep 2
    fi
}

# Check and kill process on port 8000 if in use
if check_port 8000; then
    kill_port 8000
fi

# Start PHP development server
echo -e "${GREEN}Starting PHP development server...${NC}"
php -S localhost:8000 -t admin_dashboard &
PHP_PID=$!

# Change to Flutter app directory
cd property_app

# Get Flutter dependencies
echo -e "\n${GREEN}Getting Flutter dependencies...${NC}"
flutter pub get

# Start Flutter app
echo -e "\n${GREEN}Starting Flutter app...${NC}"
flutter run -d chrome &
FLUTTER_PID=$!

# Function to cleanup processes on script termination
cleanup() {
    echo -e "\n${YELLOW}Shutting down servers...${NC}"
    kill $PHP_PID 2>/dev/null
    kill $FLUTTER_PID 2>/dev/null
    exit 0
}

# Register cleanup function for script termination
trap cleanup SIGINT SIGTERM

echo -e "\n${GREEN}Development servers are running:${NC}"
echo -e "Admin Dashboard: ${YELLOW}http://localhost:8000${NC}"
echo -e "Flutter App: ${YELLOW}Running in Chrome${NC}"
echo -e "\n${GREEN}Press Ctrl+C to stop the servers${NC}"

# Keep script running
wait

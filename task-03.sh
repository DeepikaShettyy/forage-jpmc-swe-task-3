#!/bin/bash
# JP Morgan & Chase
# Forage Job Simulation: Task 3

# Function to compare two version strings
version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# Function to handle errors
handle_error() {
    echo "Error occurred: $1"
    exit 1
}

# Check if the latest version of Node.js is installed
if version_gt "$(node --version)" "$(npm view node version)"; then
    echo "Updating Node.js to the latest version..."
    npm install -g npm@latest
    npm install -g n
    if ! n latest; then
        handle_error "Failed to update Node.js. Please check npm logs for errors."
    fi
    echo "Node.js updated to the latest version."
else
    echo "Node.js is already up to date."
fi

# Check if JP Chase & Morgan's Perspective module is installed
if npm list jp-chase-morgans-perspective &>/dev/null; then
    echo "JP Chase & Morgan's Perspective module is already installed."
else
    echo "JP Chase & Morgan's Perspective module is not installed. Installing..."
    if ! npm install jp-chase-morgans-perspective; then
        handle_error "Failed to install JP Chase & Morgan's Perspective module. Please check npm logs for errors."
    fi
    echo "JP Chase & Morgan's Perspective module installed successfully."
fi

# Update all packages to the latest versions
echo "Updating all packages to the latest versions..."
if ! npm update; then
    handle_error "Failed to update packages. Please check npm logs for errors."
fi
echo "All packages updated successfully."

# Installs project dependencies
echo "Installing project dependencies..."
if ! npm install; then
    handle_error "Failed to install project dependencies. Please check npm logs for errors."
fi
echo "Dependencies installed successfully."

# Build the application
echo "Building the application..."
if ! npm run build; then
    handle_error "Failed to build the application. Please check npm logs for errors."
fi
echo "Application build successful."

# Start the Python server
echo "Starting the Python server..."
if ! python datafeed/server3.py; then
    handle_error "Failed to start the Python server. Please check Python logs for errors."
fi
echo "Python server started successfully."

# Start the application
echo "Starting the application..."
if ! npm start; then
    handle_error "Failed to start the application. Please check npm logs for errors."
fi
echo "Application started successfully."

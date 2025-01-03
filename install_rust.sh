#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Rust is already installed
if command_exists rustc && command_exists cargo; then
    echo "Rust and Cargo are already installed."
    rustc --version
    cargo --version
    exit 0
fi

# Install Rust and Cargo using rustup
echo "Installing Rust and Cargo..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust and Cargo to PATH in ~/.bashrc
if ! grep -q 'export PATH="$HOME/.cargo/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    echo "Added Rust and Cargo to PATH in ~/.bashrc"
fi

# Source the environment immediately after installation
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
    echo "Sourced Rust environment from $HOME/.cargo/env"
else
    echo "Rust environment file not found. Please restart your shell manually."
    exit 1
fi

# Verify installation
if command_exists rustc && command_exists cargo; then
    echo "Rust and Cargo installed successfully."
    rustc --version
    cargo --version
else
    echo "Rust installation failed."
    exit 1
fi

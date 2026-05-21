#!/usr/bin/env bash

set -e

BINARY_NAME="tinyefi"
INSTALL_DIR="/usr/local/bin"
BUILD_DIR="$(pwd)/build"
BINARY_PATH="$BUILD_DIR/$BINARY_NAME"

echo "==> Building $BINARY_NAME..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
cd - > /dev/null

if [ ! -f "$BINARY_PATH" ]; then
    echo "Error: Build failed — binary not found at $BINARY_PATH"
    exit 1
fi

echo "==> Installing $BINARY_NAME to $INSTALL_DIR..."

if [ -L "$INSTALL_DIR/$BINARY_NAME" ]; then
    echo "    Removing existing symlink..."
    sudo rm "$INSTALL_DIR/$BINARY_NAME"
elif [ -f "$INSTALL_DIR/$BINARY_NAME" ]; then
    echo "    Removing existing binary..."
    sudo rm "$INSTALL_DIR/$BINARY_NAME"
fi

sudo ln -s "$BINARY_PATH" "$INSTALL_DIR/$BINARY_NAME"

echo "Done."

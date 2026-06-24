#!/usr/bin/env bash
# ~/nixos-config/scripts/bootstrap.sh
# Bootstrap a fresh NixOS install with this config.
# Run this from a live USB or fresh NixOS install.

set -euo pipefail

REPO_DIR="$HOME/nixos-config"

echo "==> Cloning nixos-config..."
if [ -d "$REPO_DIR" ]; then
    echo "Directory already exists, pulling latest..."
    cd "$REPO_DIR" && git pull
else
    # TODO: Update this URL once you push to a repo
    echo "NOTE: Update this script with your repo URL before running on a new machine."
    echo "For now, copy this directory to the new machine and run:"
    echo "  sudo nixos-rebuild switch --flake ~/nixos-config#default"
    exit 0
fi

echo "==> Generating hardware configuration..."
sudo nixos-generate-config --show-hardware-config > "$REPO_DIR/hardware-configuration.nix"

echo "==> Building NixOS configuration..."
sudo nixos-rebuild switch --flake "$REPO_DIR#default"

echo "==> Done! Reboot recommended."

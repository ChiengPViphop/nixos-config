#!/usr/bin/env bash
# ~/nixos-config/scripts/update.sh
# Update flake inputs and rebuild

set -euo pipefail

cd ~/nixos-config

echo "==> Updating flake inputs..."
nix flake update

echo "==> Rebuilding NixOS with updated flake..."
sudo nixos-rebuild switch --flake .#default

echo "==> Done!"

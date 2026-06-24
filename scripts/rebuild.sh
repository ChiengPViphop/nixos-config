#!/usr/bin/env bash
# ~/nixos-config/scripts/rebuild.sh
# Rebuild the system using the flake

set -euo pipefail

cd ~/nixos-config

echo "==> Rebuilding NixOS with flake..."
sudo nixos-rebuild switch --flake .#default

echo "==> Done!"

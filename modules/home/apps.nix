# ~/nixos-config/modules/home/apps.nix
# User packages — add your apps here
#
# Pattern: use unstable.<name> for any package pulled from nixpkgs-unstable.
# This avoids collisions with system-level packages (which use stable pkgs).
# To switch a package to unstable, rename it to unstable.<name>.
# To switch back to stable, rename it to just <name>.
{ config, pkgs, lib, pkgs-unstable, ... }:

let
  unstable = pkgs-unstable;
in {
  home.packages = with pkgs; [
    # ── Development (unstable) ────────────────────────────────
    unstable.git
    unstable.gh                    # GitHub CLI
    unstable.vscodium
    unstable.lazygit               # Git TUI
    unstable.delta                 # Better git diffs
    unstable.opencode

    # ── CLI tools (unstable) ──────────────────────────────────
    unstable.ripgrep
    unstable.nodejs
    unstable.fd
    unstable.eza
    unstable.bat
    unstable.fzf
    unstable.starship              # Shell prompt
    unstable.btop
    unstable.fastfetch
    unstable.jq
    unstable.yq
    unstable.tree
    unstable.unzip
    unstable.p7zip
    unstable.wget
    unstable.curlie                # curl with httpie syntax

    # ── Media (unstable) ──────────────────────────────────────
    unstable.mpv
    unstable.imv
    unstable.ffmpeg

    # ── Communication (unstable) ──────────────────────────────
    unstable.discord
    unstable.telegram-desktop
    unstable.ayugram-desktop

    # ── Misc (unstable) ───────────────────────────────────────
    unstable.gnome-secrets
    unstable.keepassxc
    unstable.obsidian
    unstable.libreoffice-fresh
    unstable.tradingview
  ];
}

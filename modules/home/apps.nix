# ~/nixos-config/modules/home/apps.nix
# User packages — add your apps here
{ config, pkgs, lib, pkgs-unstable, inputs, ... }:

let
  unstable = pkgs-unstable;
in {
  home.packages = with pkgs; [
    # ── Development ──────────────────────────────────────────
    git
    gh                    # GitHub CLI
    unstable.vscodium
    lazygit               # Git TUI
    delta                 # Better git diffs

    # ── CLI tools ────────────────────────────────────────────
    ripgrep
    nodejs
    fd
    eza
    bat
    fzf
    zoxide                # Smarter cd
    starship              # Shell prompt
    btop
    fastfetch
    jq
    yq
    tree
    unzip
    p7zip
    wget
    curlie                # curl with httpie syntax

    # ── Media ────────────────────────────────────────────────
    mpv
    imv
    ffmpeg

    # ── Communication ────────────────────────────────────────
    unstable.discord
    unstable.telegram-desktop
    unstable.ayugram-desktop
    
    # ── Misc ─────────────────────────────────────────────────
    gnome-secrets
    keepassxc
    unstable.obsidian
    libreoffice-fresh
    tradingview
    
  ];
}

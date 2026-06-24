# ~/nixos-config/modules/system/default.nix
# Core system configuration

{ config, pkgs, lib, username, hostname, inputs, ... }:

{
  # ── Hostname ──────────────────────────────────────────────
  networking.hostName = lib.mkForce hostname;

  # ── Bootloader ────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ── Networking ────────────────────────────────────────────
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # ── Time zone & locale ────────────────────────────────────
  time.timeZone = "Asia/Phnom_Penh";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ── Console ───────────────────────────────────────────────
  console.keyMap = "us";

  # ── Sound (Pipewire) ──────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── Printing ──────────────────────────────────────────────
  services.printing.enable = true;

  # ── User account ──────────────────────────────────────────
  users.users.${username} = {
    isNormalUser = true;
    description = "Phouvongviphop Chieng";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;

  # ── Nix settings ──────────────────────────────────────────
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      # Use all cores for builds
      max-jobs = "auto";
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # ── System packages ───────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Essentials
    vim
    wget
    curl
    htop
    unzip
    psmisc
    usbutils
    pciutils
    neovim
    micro

    # Networking
    networkmanagerapplet

    # CLI tools (stable — unstable versions managed in Home Manager)
    tree

    # File manager
    nemo-with-extensions

    # Browser
    firefox
    brave
    chromium

    # Noctalia shell
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # ── Fonts ─────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # ── Services ──────────────────────────────────────────────
  services.gvfs.enable = true;  # Trash, archive, mounting in file manager
  services.tumbler.enable = true;  # Thumbnail service
  services.blueman.enable = true;  # Bluetooth

  # Required for Noctalia (bluetooth support)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable dconf for GNOME-based tools (many apps need it)
  programs.dconf.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any common libraries if workerd complains about missing .so files later
    stdenv.cc.cc
    openssl
  ];

  # ── State version (DO NOT CHANGE after initial install) ───
  system.stateVersion = "25.05";
}

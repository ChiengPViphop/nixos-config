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
  networking.firewall.allowedTCPPorts = [ 8081 53317 19000 19001 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

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

  # ── OpenGL / Graphics ────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ── Steam ─────────────────────────────────────────────────
  programs.steam.enable = true;

  # ── Printing ──────────────────────────────────────────────
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-201401w ];

  # udev rules for Gecko POS printer (Epson 04b8:08d1) over USB
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="04b8", ATTR{idProduct}=="08d1", MODE="0666", GROUP="users", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idClass}=="07", MODE="0666", GROUP="users", TAG+="uaccess"
  '';

  # ── User account ──────────────────────────────────────────
  users.users.${username} = {
    isNormalUser = true;
    description = "Phouvongviphop Chieng";
    initialPassword = "changeme";  # ← change immediately after first login
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "kvm"       # Required for WinApps (Podman/Docker needs /dev/kvm)
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

      # Binary cache for WinApps (optional, speeds up builds)
      substituters = [ "https://winapps.cachix.org/" ];
      trusted-public-keys = [ "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g=" ];
      trusted-users = [ username ];
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
    epson-201401w
    openssl


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

    # WinApps — run Windows apps on Linux
    inputs.winapps.packages.${pkgs.system}.winapps
    inputs.winapps.packages.${pkgs.system}.winapps-launcher  # optional GUI launcher

    # Podman compose (for WinApps Windows VM)
    podman-compose

    # FreeRDP (needed for testing RDP connection standalone)
    freerdp

    # dialog (needed by winapps-setup dependency check)
    dialog

    #extra
    flatpak
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

  # ── Podman (WinApps backend) ─────────────────────────────
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Required for WinApps folder sharing with the host
  boot.kernelModules = [ "ip_tables" "iptable_nat" ];

  programs.nix-ld.libraries = with pkgs; [
    # Add any common libraries if workerd complains about missing .so files later
    stdenv.cc.cc
    openssl
  ];

  # ── State version (DO NOT CHANGE after initial install) ───
  system.stateVersion = "25.05";
}

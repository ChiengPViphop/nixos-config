# ~/nixos-config/modules/desktop/default.nix
# Niri Wayland compositor + display manager configuration

{ config, pkgs, lib, inputs, ... }:

let
  # Script to launch Niri from display manager
  niri-session = pkgs.writeShellScriptBin "niri-session" ''
    # Set cursor theme
    export XCURSOR_THEME=capitaine-cursors
    export XCURSOR_SIZE=24

    # wayland session variables
    export NIXOS_OZONE_WL=1
    export MOZ_ENABLE_WAYLAND=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export SDL_VIDEODRIVER=wayland
    export GBM_BACKEND=nvidia-drm
    export CLUTTER_BACKEND=wayland

    # Start niri
    exec niri session start
  '';

in {
  # ── Import Niri flake module ──────────────────────────────
  imports = [ inputs.niri.nixosModules.niri ];

  # ── Niri ──────────────────────────────────────────────────
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # ── Display Manager ───────────────────────────────────────
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # ── XDG Portal for Wayland apps ──────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # ── Desktop packages ──────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Niri launcher
    niri-session

    # Wayland essentials
    fnott                # Notification daemon (Wayland-native)
    swaylock             # Screen locker
    swayidle             # Idle manager
    wl-clipboard         # Clipboard utilities
    grim                 # Screenshot tool
    slurp                # Screen region selector
    satty                # Screenshot editor
    wf-recorder          # Screen recorder

    # Theming
    adwaita-icon-theme
    adwaita-qt
    capitaine-cursors
    papirus-icon-theme

    # Media (mpv provided via Home Manager)
    imv                 # Image viewer (Wayland)
    loupe               # GNOME image viewer

    # Authentication agent
    polkit_gnome

    # Lock screen
    swaylock-effects
    wlogout             # Logout menu
  ];

  # ── Polkit agent (needed for graphical authentication) ────
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # ── KDE Connect / NetworkManager applet ──────────────────
  programs.kdeconnect.enable = true;

  # ── Power management ──────────────────────────────────────
  services.upower.enable = true;

  # ── Auto-brightness / power saving ────────────────────────
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;

  # ── GNOME keyring (for secrets / wifi passwords) ─────────
  services.gnome.gnome-keyring.enable = true;
}

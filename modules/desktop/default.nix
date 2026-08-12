# ~/nixos-config/modules/desktop/default.nix
# Niri Wayland compositor + display manager configuration

{ config, pkgs, lib, username, inputs, ... }:

let
  # Script to launch Niri from display manager
  niri-session = pkgs.writeShellScriptBin "niri-session" ''
    # Set cursor theme
    export XCURSOR_THEME=capitaine-cursors
    export XCURSOR_SIZE=24

    # Wayland session variables
    export NIXOS_OZONE_WL=1
    export MOZ_ENABLE_WAYLAND=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export SDL_VIDEODRIVER=wayland
    export CLUTTER_BACKEND=wayland

    # GBM backend for graphics
    export GBM_BACKEND=drm

    # Start niri
    exec niri session start
  '';

in {
  # ── Import Niri flake module ──────────────────────────────
  imports = [
    inputs.niri.nixosModules.niri
    inputs.noctalia-greeter.nixosModules.default
  ];

  # ── Niri ──────────────────────────────────────────────────
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # ── Xwayland (needed for X11 apps like WinApps/FreeRDP) ──
  programs.xwayland.enable = true;

  # ── Noctalia Greeter (greetd login screen) ───────────────
  # The module enables greetd + accounts-daemon and sets the
  # default_session command to noctalia-greeter-session.
  programs.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "niri";
      user.default = username;
      appearance = {
        scheme = "Catppuccin";
        theme_mode = "dark";
      };
      cursor = {
        theme = "capitaine-cursors";
        size = 24;
        path = "${pkgs.capitaine-cursors}/share/icons";
      };
      keyboard = {
        layout = "us";
      };
    };
  };

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
    xwayland-satellite   # X11 support for niri 25.08+

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


  # ── Power management ──────────────────────────────────────
  services.upower.enable = true;

  # ── Auto-brightness / power saving ────────────────────────
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;

  # ── GNOME keyring (for secrets / wifi passwords) ─────────
  services.gnome.gnome-keyring.enable = true;
}

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

  # Android SDK — platform 36 + build-tools 36.0.0 + latest cmdline-tools
  # + emulator with google_apis system image (x86_64).
  androidSdk = (pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "36" ];
    buildToolsVersions = [ "36.0.0" ];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ "google_apis" ];
    abiVersions = [ "x86_64" ];
    includeNDK = false;
  }).androidsdk;
in {
  # ANDROID_HOME → writable SDK mirror at the standard ~/Android/sdk location.
  # The mirror (created by the activation script below) has a wrapped emulator
  # forcing QT_QPA_PLATFORM=xcb, so Expo's auto-spawn works (it execs
  # $ANDROID_HOME/emulator/emulator directly, bypassing shell aliases).
  home.sessionVariables.ANDROID_HOME = "${config.home.homeDirectory}/Android/sdk";

  # Build the SDK mirror: symlink everything from the nix store, but replace
  # emulator/emulator with a wrapper that forces the xcb Qt platform (the
  # bundled Qt has no wayland plugin). Regenerated on every HM activation.
  home.activation.createAndroidSdkMirror = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SDK=${androidSdk}/libexec/android-sdk
    DEST="$HOME/Android/sdk"
    rm -rf "$DEST"
    mkdir -p "$DEST/emulator"
    for d in "$SDK"/*; do
      if [ "$(basename "$d")" = "emulator" ]; then
        ln -s "$SDK/emulator/"* "$DEST/emulator/"
      else
        ln -s "$d" "$DEST/"
      fi
    done
    # Replace the symlinked emulator binary with a wrapper (rm first — cat
    # would otherwise write through the symlink into the read-only store).
    rm "$DEST/emulator/emulator"
    cat > "$DEST/emulator/emulator" <<'WRAPPER'
#!/bin/sh
exec env QT_QPA_PLATFORM=xcb "$REAL_EMU" "$@"
WRAPPER
    sed -i "s|\$REAL_EMU|$SDK/emulator/emulator|" "$DEST/emulator/emulator"
    chmod +x "$DEST/emulator/emulator"
  '';

  home.packages = with pkgs; [
    # ── Development (unstable) ────────────────────────────────
    unstable.git
    unstable.gh                    # GitHub CLI
    unstable.vscodium
    unstable.lazygit               # Git TUI
    unstable.delta                 # Better git diffs
    unstable.opencode
    androidSdk                     # Android SDK
    unstable.jdk17                 # Required by sdkmanager / Gradle builds

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
    unstable.pdfarranger
    unstable.inkscape-with-extensions
    unstable.localsend
    unstable.handbrake
    unstable.kdePackages.kdenlive
    unstable.gimp-with-plugins
    unstable.krita
    unstable.opencode-desktop
    unstable.steam
    unstable.proton-vpn
    unstable.anydesk
    unstable.android-studio
    unstable.gnome-disk-utility
    
    # ── ani-cli v4.15+ (local git repo) ──────────────────────────
    # system package is outdated/broken — using ~/ani-cli/ani-cli via wrapper
    unstable.botan3              # AES-256-GCM crypto for allanime scraping
  ];
}

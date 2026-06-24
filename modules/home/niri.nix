# Home Manager niri configuration
# Import this from home/default.nix with: imports = [ ./niri.nix ];
{ config, pkgs, ... }:

{
  # ─── Niri config file ──────────────────────────────────────────
  home.file.".config/niri/config.kdl".force = true;
  home.file.".config/niri/config.kdl".text = ''
    // ─── Animations ───
    animations {
        workspace-switch {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }
        window-open {
            duration-ms 200
            curve "ease-out-quad"
        }
        window-close {
            duration-ms 200
            curve "ease-out-cubic"
        }
        horizontal-view-movement {
            spring damping-ratio=1.0 stiffness=900 epsilon=0.0001
        }
        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }
        config-notification-open-close {
            spring damping-ratio=0.6 stiffness=1200 epsilon=0.001
        }
        screenshot-ui-open {
            duration-ms 300
            curve "ease-out-quad"
        }
        overview-open-close {
            spring damping-ratio=1.0 stiffness=900 epsilon=0.0001
        }
    }

    // ─── Startup Applications ───
    // Noctalia is started via systemd service (programs.noctalia.systemd.enable)

    // ─── Output Configuration ───
    // You can run `niri msg outputs` to get the correct name for your displays.
    // Uncomment and edit the output name/params for your setup.
    /- output "DP-1" {
        mode "2560x1440@359.979"
        scale 1
    }

    // ─── Input Configuration ───
    input {
        keyboard {
            xkb {
                layout "us,kh"
                options "grp:alt_shift_toggle"
            }
            numlock
        }

        touchpad {
            tap
            natural-scroll
        }

        mouse {
            // accel-profile "flat"
            // accel-speed 0.0
        }

        focus-follows-mouse
        workspace-auto-back-and-forth
    }

    // ─── Keybindings ───
    binds {
        Mod+Shift+ESCAPE                     { show-hotkey-overlay; }

        // Applications
        Mod+Return                           hotkey-overlay-title="Open Terminal" { spawn "alacritty"; }
        Mod+A                                hotkey-overlay-title="Open App Launcher: noctalia" { spawn-sh "noctalia msg panel-toggle launcher"; }
        Mod+B                                hotkey-overlay-title="Open Browser: brave" { spawn "brave"; }
        Mod+ALT+L                            hotkey-overlay-title="Lock Screen: niri lock" { spawn "niri" "msg" "lock-session"; }
        Mod+Shift+Q                          hotkey-overlay-title="Session Menu: niri power-menu" { spawn "niri" "msg" "power-menu"; }
        Mod+E                                hotkey-overlay-title="File Manager" { spawn "nemo"; }

        // Media Controls
        XF86AudioRaiseVolume                 allow-when-locked=true { spawn-sh "noctalia msg brightness-up"; }
        XF86AudioLowerVolume                 allow-when-locked=true { spawn-sh "noctalia msg brightness-down"; }
        XF86AudioMute                        allow-when-locked=true { spawn-sh "noctalia msg volume-mute"; }
        XF86AudioMicMute                     allow-when-locked=true { spawn-sh "noctalia msg mic-mute"; }
        XF86AudioNext                        allow-when-locked=true { spawn-sh "noctalia msg media next"; }
        XF86AudioPrev                        allow-when-locked=true { spawn-sh "noctalia msg media previous"; }
        XF86AudioPlay                        allow-when-locked=true { spawn-sh "noctalia msg media toggle"; }
        XF86AudioPause                       allow-when-locked=true { spawn-sh "noctalia msg media toggle"; }

        // Brightness Controls
        XF86MonBrightnessUp                  allow-when-locked=true { spawn-sh "brightnessctl set +5%"; }
        XF86MonBrightnessDown                allow-when-locked=true { spawn-sh "brightnessctl set 5%-"; }

        // Window Movement and Focus
        Mod+Q                                { close-window; }

        Mod+Left                             { focus-column-left; }
        Mod+H                                { focus-column-left; }
        Mod+Right                            { focus-column-right; }
        Mod+L                                { focus-column-right; }
        Mod+Up                               { focus-window-up; }
        Mod+K                                { focus-window-up; }
        Mod+Down                             { focus-window-down; }
        Mod+J                                { focus-window-down; }

        Mod+CTRL+Left                        { move-column-left; }
        Mod+CTRL+H                           { move-column-left; }
        Mod+CTRL+Right                       { move-column-right; }
        Mod+CTRL+L                           { move-column-right; }
        Mod+CTRL+Up                          { move-window-up; }
        Mod+CTRL+K                           { move-window-up; }
        Mod+CTRL+Down                        { move-window-down; }
        Mod+CTRL+J                           { move-window-down; }

        Mod+Home                             { focus-column-first; }
        Mod+End                              { focus-column-last; }
        Mod+CTRL+Home                        { move-column-to-first; }
        Mod+CTRL+End                         { move-column-to-last; }

        Mod+Shift+Left                       { focus-monitor-left; }
        Mod+Shift+Right                      { focus-monitor-right; }
        Mod+Shift+Up                         { focus-monitor-up; }
        Mod+Shift+Down                       { focus-monitor-down; }

        Mod+Shift+CTRL+Left                  { move-column-to-monitor-left; }
        Mod+Shift+CTRL+Right                 { move-column-to-monitor-right; }
        Mod+Shift+CTRL+Up                    { move-column-to-monitor-up; }
        Mod+Shift+CTRL+Down                  { move-column-to-monitor-down; }

        // Workspace Switching
        Mod+WheelScrollDown                  cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp                    cooldown-ms=150 { focus-workspace-up; }
        Mod+CTRL+WheelScrollDown             cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+CTRL+WheelScrollUp               cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight                 { focus-column-right; }
        Mod+WheelScrollLeft                  { focus-column-left; }
        Mod+CTRL+WheelScrollRight            { move-column-right; }
        Mod+CTRL+WheelScrollLeft             { move-column-left; }

        Mod+Shift+WheelScrollDown            { focus-column-right; }
        Mod+Shift+WheelScrollUp              { focus-column-left; }
        Mod+CTRL+Shift+WheelScrollDown       { move-column-right; }
        Mod+CTRL+Shift+WheelScrollUp         { move-column-left; }

        Mod+1                                { focus-workspace 1; }
        Mod+2                                { focus-workspace 2; }
        Mod+3                                { focus-workspace 3; }
        Mod+4                                { focus-workspace 4; }
        Mod+5                                { focus-workspace 5; }
        Mod+6                                { focus-workspace 6; }
        Mod+7                                { focus-workspace 7; }
        Mod+8                                { focus-workspace 8; }
        Mod+9                                { focus-workspace 9; }

        Mod+SHIFT+1                          { move-column-to-workspace 1; }
        Mod+SHIFT+2                          { move-column-to-workspace 2; }
        Mod+SHIFT+3                          { move-column-to-workspace 3; }
        Mod+SHIFT+4                          { move-column-to-workspace 4; }
        Mod+SHIFT+5                          { move-column-to-workspace 5; }
        Mod+SHIFT+6                          { move-column-to-workspace 6; }
        Mod+SHIFT+7                          { move-column-to-workspace 7; }
        Mod+SHIFT+8                          { move-column-to-workspace 8; }
        Mod+SHIFT+9                          { move-column-to-workspace 9; }

        Mod+TAB                              { focus-workspace-previous; }

        // Layout Controls
        Mod+F                                { maximize-column; }
        Mod+C                                { center-column; }
        Mod+CTRL+C                           { center-visible-columns; }
        Mod+Minus                            { set-column-width "-10%"; }
        Mod+Equal                            { set-column-width "+10%"; }
        Mod+Shift+Minus                      { set-window-height "-10%"; }
        Mod+Shift+Equal                      { set-window-height "+10%"; }

        // Modes
        Mod+V                                { toggle-window-floating; }
        Mod+Shift+F                          { fullscreen-window; }
        Mod+W                                { toggle-column-tabbed-display; }

        // Screenshots
        Mod+S                                { screenshot; }
        Mod+Shift+S                          { screenshot-screen; }
        Mod+CTRL+S                           { screenshot-window; }

        // Emergency Escape Key
        Mod+ESCAPE                           allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        // Exit / Power
        CTRL+ALT+Delete                      { quit; }
        Mod+Shift+P                          { power-off-monitors; }
        Mod+O                                repeat=false { toggle-overview; }
    }

    // ─── Layout ───
    layout {
        gaps 16
        center-focused-column "never"
        background-color "transparent"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        struts {}
    }

    // ─── Window Rules ───
    window-rule {
        geometry-corner-radius 20
        clip-to-geometry true
    }

    window-rule {
        match app-id="steam"
        exclude title=r#"^[Ss]team$"#
        open-floating true
    }

    window-rule {
        match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
        default-floating-position x=10 y=10 relative-to="bottom-right"
        open-focused false
    }

    layer-rule {
        match namespace="^noctalia-wallpaper*"
        place-within-backdrop true
    }

    window-rule {
        match is-active=false
        opacity 0.9
    }

    // ─── Miscellaneous ───
    prefer-no-csd
    screenshot-path null

    cursor {
        xcursor-theme "capitaine-cursors"
        xcursor-size 24
    }

    debug {
        honor-xdg-activation-with-invalid-serial
    }

    hotkey-overlay {
        skip-at-startup
    }
  '';

  # ── Environment variables for Wayland apps ────────────────────
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };
}

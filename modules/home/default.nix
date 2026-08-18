# ~/nixos-config/modules/home/default.nix
# Home Manager configuration — user-level dotfiles and packages

{ config, pkgs, lib, pkgs-unstable, username, inputs, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  # ── Imports ────────────────────────────────────────────────
  imports = [
    inputs.noctalia.homeModules.default
    ./niri.nix
    ./apps.nix
  ];

  # ── Noctalia settings ──────────────────────────────────────
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "/home/${username}/Pictures/wallpapers";
      };

      shell = {
        niri_overview_type_to_launch_enabled = true;
      };

      launch_apps_as_systemd_services = true;
    };
  };

  # ── Shell (Fish) ──────────────────────────────────────────
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Hermes in-app terminal inherits __HM_SESS_VARS_SOURCED=1, which makes
      # hm-session-vars.fish return early (ANDROID_HOME etc. never exported).
      # Clear the guard and re-source so session vars always apply.
      if set -q __HM_SESS_VARS_SOURCED
        set -e __HM_SESS_VARS_SOURCED
        source (sed -n 's/^source //p' ~/.config/fish/config.fish | head -1)
      end
      set -U fish_greeting
      fish_vi_key_bindings
      starship init fish | source
      zoxide init fish | source
      fzf --fish | source
    '';
    shellAliases = {
      ll = "eza -l --icons --git";
      la = "eza -la --icons --git";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";
      fetch = "fastfetch";
      rs = "sudo nixos-rebuild switch --flake ~/nixos-config#default";
      update = "cd ~/nixos-config && nix flake update && sudo nixos-rebuild switch --flake ~/nixos-config#default";
      gc = "sudo nix-collect-garbage -d";
      anime = "~/.local/bin/ani-cli";
      emulator = "env QT_QPA_PLATFORM=xcb emulator";  # Qt wayland plugin missing from Android emulator
    };
  };

  # ── Starship prompt ───────────────────────────────────────
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs-unstable.starship;
    settings = {
      add_newline = true;
      format = "$directory$git_branch$git_status$character";
      directory.style = "bold blue";
      git_branch.style = "bold purple";
      character.success_symbol = "[❯](bold green)";
      character.error_symbol = "[❯](bold red)";
    };
  };

  # ── Zoxide ────────────────────────────────────────────────
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs-unstable.zoxide;
  };

  # ── FZF ──────────────────────────────────────────────────
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs-unstable.fzf;
  };

  # ── Git ───────────────────────────────────────────────────
  programs.git = {
    enable = true;
    package = pkgs-unstable.git;
    userName = "ChiengPViphop";
    userEmail = "phouvongviphop@protonmail.com";
    delta.enable = true;
    delta.package = pkgs-unstable.delta;
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      core.editor = "hx";
    };
  };

  # ── Helix editor ──────────────────────────────────────────
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = pkgs-unstable.helix;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        soft-wrap.enable = true;
        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
      };
    };
    languages.language = [{
      name = "nix";
      formatter.command = "nixpkgs-fmt";
      auto-format = true;
    }];
  };

  # ── Alacritty terminal ────────────────────────────────────
  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty;
    settings = {
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 11.0;
      };
      window.opacity = 0.95;
      colors.draw_bold_text_with_bright_colors = true;
      # Ctrl+C copies when text is selected (like other apps).
      # Ctrl+Shift+C sends ^C (SIGINT), since plain Ctrl+C is now taken.
      keyboard.bindings = [
        { key = "C"; mods = "Control"; action = "Copy"; }
        { key = "C"; mods = "Control|Shift"; chars = builtins.fromJSON ''"\u0003"''; }
      ];
    };
  };


  # ── Fastfetch ─────────────────────────────────────────────
  programs.fastfetch = {
    enable = true;
    package = pkgs-unstable.fastfetch;
  };

  # ── Btop ──────────────────────────────────────────────────
  programs.btop = {
    enable = true;
    package = pkgs-unstable.btop;
    settings = {
      color_theme = "TTY";
      theme_background = false;
    };
  };

  # ── Swaylock ──────────────────────────────────────────────
  programs.swaylock = {
    enable = true;
    package = pkgs-unstable.swaylock-effects;
    settings = {
      color = "1e1e2e";
      font = "JetBrainsMono Nerd Font";
      show-failed-attempts = true;
      indicator-caps-lock = true;
      indicator-radius = 100;
      indicator-thickness = 10;
    };
  };

  # ── GTK theming ───────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 24;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraCss = ''
      @import url("noctalia.css");
    '';
  };

  # ── QT theming ────────────────────────────────────────────
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # ── dconf settings ────────────────────────────────────────
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "capitaine-cursors";
      cursor-size = 24;
    };
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "alacritty";
    };
  };
  xdg = {
    enable = true;
    # Preferred terminal for Terminal=true desktop entries (used by
    # xdg-terminal-exec when launchers open apps like micro).
    configFile."xdg-terminals.list".text = "alacritty.desktop\n";
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
    };
  };

  # ── PATH additions ─────────────────────────────────────────
  home.sessionPath = [ "$HOME/.local/bin" ];

  # ── Let Home Manager manage itself ────────────────────────
  programs.home-manager.enable = true;
}

# NixOS Configuration

Reproducible NixOS configuration with Niri Wayland compositor, Noctalia shell, and Home Manager.

## Features

- **Niri** — Wayland scrollable-tiling compositor
- **Noctalia** — Shell for Niri with launcher, control center, bar, notifications
- **GDM** — Display manager
- **Home Manager** — Declarative user configuration
- **Adwaita-dark** theme with Papirus-Dark icons
- **Capitaine-cursors** cursor theme
- **Alacritty** as default terminal (Nemo "Open in Terminal")
- **Fish** shell with Starship prompt, Zoxide, FZF
- **Helix** as default editor

## Structure

```
.
├── flake.nix                          # Main flake (inputs, outputs)
├── flake.lock                         # Pinned dependencies
├── hardware-configuration.nix          # Machine-specific (regenerate per PC)
├── qylock/                            # Local copy of qylock themes (optional)
├── modules/
│   ├── system/default.nix             # Core system: boot, network, packages, GDM, qylock
│   ├── desktop/default.nix            # Niri, GDM, Wayland tools, theming
│   └── home/
│       ├── default.nix                # Home Manager: imports, Noctalia, shell, git, themes, dconf
│       ├── apps.nix                   # User packages (edit this to add apps)
│       └── niri.nix                   # Niri config (keybinds, animations, rules)
└── scripts/
    ├── rebuild.sh                    # Quick rebuild
    ├── update.sh                      # Update flake inputs + rebuild
    └── bootstrap.sh                   # Fresh machine setup helper
```

## Quick Start on a Fresh Machine

1. Install NixOS (any desktop install is fine)
2. Clone this repo to `~/nixos-config`
3. Generate hardware config:
   ```
   sudo nixos-generate-config --show-hardware-config > ~/nixos-config/hardware-configuration.nix
   ```
4. Build:
   ```
   cd ~/nixos-config && sudo nixos-rebuild switch --flake .#default
   ```
5. Reboot

## Adding Apps

Edit `modules/home/apps.nix` and add packages to the `home.packages` list.

## Keybindings

| Key | Action |
|-----|--------|
| Mod+Return | Terminal (Alacritty) |
| Mod+D | App launcher (Fuzzel) |
| Mod+A | Noctalia launcher |
| Mod+S | Noctalia control center |
| Mod+Q | Close window |
| Mod+Shift+Q | Quit Niri |
| Mod+Alt+L | Lock screen |
| Mod+1-9 | Switch workspace |
| Mod+Shift+1-9 | Move window to workspace |

## Aliases (Fish)

| Alias | Command |
|-------|---------|
| `rebuild` | `sudo nixos-rebuild switch --flake ~/nixos-config#default` |
| `update` | `cd ~/nixos-config && nix flake update && sudo nixos-rebuild switch --flake ~/nixos-config#default` |
| `gc` | `sudo nix-collect-garbage -d` |

## Updating

```
update
```

Or just rebuild without updating flake inputs:

```
rebuild
```

## Notes

- The `hardware-configuration.nix` is machine-specific — regenerate it on each new PC
- The `flake.lock` pins all dependency versions for reproducibility
- Noctalia uses the Catppuccin dark theme via Home Manager
- GTK apps use Adwaita-dark theme with dconf `color-scheme = prefer-dark`

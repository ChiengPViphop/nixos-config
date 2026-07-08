# NixOS Configuration

Reproducible NixOS configuration with Niri Wayland compositor, Noctalia shell, and Home Manager.

## Features

- **Niri** — Wayland scrollable-tiling compositor with animations & window rules
- **Noctalia** — Shell for Niri with launcher, control center, bar, notifications
- **GNOME** — Enabled alongside Niri (provides GDM, keyring, portal integration)
- **Home Manager** — Declarative user configuration (shell, editor, theming, apps)
- **Adwaita-dark** theme with Papirus-Dark icons, Capitaine-cursors
- **Alacritty** as default terminal (Nemo "Open in Terminal")
- **Fish** shell with Starship prompt, Zoxide, FZF
- **Helix** as default editor
- **WinApps** — Run Windows apps on Linux via Podman
- **Wayland-native tooling** — fnott, grim, slurp, satty, wf-recorder, swaylock

## Structure

```
.
├── flake.nix                          # Main flake (inputs, outputs)
├── flake.lock                         # Pinned dependencies
├── hardware-configuration.nix         # Machine-specific (regenerate per PC)
├── modules/
│   ├── system/default.nix             # Core system: boot, network, packages, services
│   ├── desktop/default.nix            # Niri, GDM, Wayland tools, polkit, theming
│   └── home/
│       ├── default.nix                # Home Manager: Noctalia, Fish, git, Helix, themes, dconf
│       ├── apps.nix                   # User packages (edit this to add apps)
│       └── niri.nix                   # Niri config KDL (keybinds, animations, rules)
└── scripts/
    ├── rebuild.sh                     # Quick rebuild
    ├── update.sh                      # Update flake inputs + rebuild
    └── bootstrap.sh                   # Fresh machine setup helper
```

## Quick Start on a Fresh Machine

1. Install NixOS (any desktop install is fine)
2. Clone this repo to `~/nixos-config`
3. Generate hardware config:
   ```bash
   sudo nixos-generate-config --show-hardware-config > ~/nixos-config/hardware-configuration.nix
   ```
4. **Edit `flake.nix` for your machine** — see [Machine-Specific Values](#machine-specific-values) below
5. Build:
   ```bash
   cd ~/nixos-config && sudo nixos-rebuild switch --flake .#default
   ```
6. Reboot

### Machine-Specific Values

Before building on a new machine, edit these in `flake.nix`:

| Variable | Default | What to change |
|----------|---------|----------------|
| `system` | `"x86_64-linux"` | `"aarch64-linux"` for ARM |
| `username` | `"phouvongviphop"` | Your username |
| `hostname` | `"nixos"` | A unique hostname per machine |

Also update hardcoded wallpaper paths in `modules/desktop/default.nix` and `modules/home/default.nix` if your wallpapers live elsewhere.

## Adding Apps

Edit `modules/home/apps.nix` and add packages to the `home.packages` list. Use `unstable.<name>` for packages from nixpkgs-unstable.

## Keybindings

| Key | Action |
|-----|--------|
| **Mod+Return** | Terminal (Alacritty) |
| **Mod+Q** | Close window |
| **Mod+A** | Noctalia launcher |
| **Mod+B** | Browser (Brave) |
| **Mod+E** | File manager (Nemo) |
| **Mod+S** | Screenshot (region) |
| **Mod+Shift+S** | Screenshot (screen) |
| **Mod+Ctrl+S** | Screenshot (window) |
| **Mod+V** | Toggle window floating |
| **Mod+F** | Maximize column |
| **Mod+W** | Toggle column tabbed display |
| **Mod+O** | Toggle overview |
| **Mod+Shift+Q** | Quit Niri / power menu |
| **Mod+Alt+L** | Lock screen |
| **Mod+Left/Right/Up/Down** (or H/L/K/J) | Focus window |
| **Mod+Ctrl+Left/Right** (or H/L) | Move column |
| **Mod+Ctrl+Up/Down** (or K/J) | Move window |
| **Mod+Shift+Arrows** | Focus monitor |
| **Mod+1-9** | Switch workspace |
| **Mod+Shift+1-9** | Move window to workspace |
| **Mod+Tab** | Previous workspace |
| **Mod+Scroll** | Switch workspace |
| **Ctrl+Alt+Delete** | Quit Niri |
| **XF86Audio* / XF86MonBrightness*** | Media / brightness controls (via Noctalia) |
| **Mod+Esc** | Toggle keyboard shortcuts inhibit (emergency release) |

## Aliases (Fish)

| Alias | Command |
|-------|---------|
| `rs` | `sudo nixos-rebuild switch --flake ~/nixos-config#default` |
| `update` | `cd ~/nixos-config && nix flake update && sudo nixos-rebuild switch --flake ~/nixos-config#default` |
| `gc` | `sudo nix-collect-garbage -d` |

## Updating

```bash
update
```

Or just rebuild without updating flake inputs:

```bash
rs
```

## Notes

- The `hardware-configuration.nix` is machine-specific — regenerate it on each new PC
- The `flake.lock` pins all dependency versions for reproducibility
- Noctalia uses the Catppuccin dark theme via Home Manager, pulled from its binary cache (`noctalia.cachix.org`)
- GTK apps use Adwaita-dark theme with dconf `color-scheme = prefer-dark`
- **Noctalia binary cache** is configured in `flake.nix` (`nixConfig`) — no manual setup needed
- The repo also pulls in: `nixos-hardware`, `ayugram-desktop`, `winapps` flakes
- `bootstrap.sh` is a skeleton — requires editing the repo URL before it can be used

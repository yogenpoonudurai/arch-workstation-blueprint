# dotfiles — plain Arch Hyprland workstation (Noctalia shell)

Fast, coherent, no distro branding. Lua-only Hyprland + Noctalia menus/bar.

## Install (existing machine)
```bash
~/dotfiles/install.sh
hyprctl reload
```

## Fresh PC (after archinstall)
```bash
git clone <your-dotfiles-remote> ~/dotfiles && ~/dotfiles/bootstrap.sh
# bootstrap: trusted repository packages → dotfiles → security baseline →
# install.sh symlinks → rustup/go/pnpm/cargo/starship → enables
# NetworkManager+bluetooth (tailscale installed, `sudo tailscale up` left manual)
# Manual after: audit AUR PKGBUILDs, chsh zsh, hardened UKI test, Tailscale auth
```

Disk encryption is installation-time, never automated by the bootstrap. Recommended layout:

```text
4 GB    EFI (FAT32, /boot)
320 GB  LUKS2 → Btrfs (@, @home, @log, @snapshots)
rest    LUKS2 → ext4 (/mnt/Development)
```

Keep `linux` as a recovery kernel. Run `install/security-hardened-uki.sh`, test its
UKI once, then make it default only after Wi-Fi, audio, lock, and suspend pass.

## Layout
- `.config/hypr/hyprland.lua` + `config/{theme,monitors,input,environment,appearance,animations,bindings,rules,autostart}.lua` + `scripts/`
- `.config/noctalia/config.toml` — single shell (bar/launcher/notifications/control-center/dock off)
- `.config/{alacritty,nvim,tmux,gtk-3.0,matugen,theme}/`
- `.local/bin/` — `screenshot-satty`, `monitor-ctl`, `package-install/remove`, `theme-set/render/from-wallpaper`
- `packages/{pacman,aur,cargo,go,pnpm}.txt` + `bootstrap.sh`
- `install/security-{postinstall,hardened-uki,verify}.sh` — security setup and checks
- `scripts/backup-restic` — encrypted pre-install backup helper
- `.zprofile .zshrc .tmux.conf`

## Security

```bash
install/security-postinstall.sh
install/security-hardened-uki.sh
install/security-verify.sh
```

The baseline enables AppArmor, UFW (deny inbound), fstrim, GCR
SSH agent, PAM keyring unlock, Hyprland screencopy enforcement, and hardened-kernel
verification. LUKS passphrases, Restic passwords, Tailscale tokens, and Secure Boot
keys never belong in this repository.

AUR installation is intentionally manual: inspect the complete PKGBUILD checkout,
sources, patches, and install hooks for every entry in `packages/aur.txt`. Open only
specific firewall ports when a service needs them; Tailnet peers are not implicitly trusted.

Backup example:

```bash
scripts/backup-restic "/run/media/$USER/Backup Drive/Backup/restic-arch"
```

## Theme
```bash
theme-set oled-default|tokyo-night|catppuccin  # instant preset, no logout
theme-from-wallpaper ~/Pictures/Wallpapers/your.jpg  # matugen-driven
```

## Perf
```bash
time zsh -i -c exit
nvim --startuptime /tmp/nvim-start.log +qa && tail -5 /tmp/nvim-start.log
```

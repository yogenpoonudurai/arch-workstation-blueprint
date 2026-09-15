# dotfiles — plain Arch Hyprland workstation

Fast, coherent, no distro branding. Lua-only Hyprland.

## Install (existing machine)
```bash
~/dotfiles/install.sh
hyprctl reload
```

## Fresh PC (after archinstall)
```bash
git clone <your-dotfiles-remote> ~/dotfiles && ~/dotfiles/bootstrap.sh
# bootstrap: paru-bin → packages/pacman.txt + packages/aur.txt →
# install.sh symlinks → rustup/go/pnpm/cargo/OMZ → enables
# NetworkManager+bluetooth (tailscale installed, `sudo tailscale up` left manual)
# Manual after: chsh zsh, keyring PAM lines, reboot
```

## Layout
- `.config/hypr/hyprland.lua` + `config/{theme,monitors,input,environment,appearance,animations,bindings,rules,autostart}.lua` + `scripts/`
- `.config/noctalia/config.toml` — single shell (bar/launcher/notifications/control-center/dock off)
- `.config/{alacritty,nvim,tmux,gtk-3.0,matugen,theme}/`
- `packages/{pacman,aur,cargo,go,pnpm}.txt` + `bootstrap.sh`
- `.zprofile .zshrc .tmux.conf`

## Theme
```bash
theme-from-wallpaper ~/Pictures/Wallpapers/your.jpg
```

## Perf
```bash
time zsh -i -c exit
nvim --startuptime /tmp/nvim-start.log +qa && tail -5 /tmp/nvim-start.log
```

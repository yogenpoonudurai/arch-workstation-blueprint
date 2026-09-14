# dotfiles — plain Arch Hyprland workstation

Fast, coherent, no distro branding. Lua-only Hyprland.

## Install
```bash
~/dotfiles/install.sh
hyprctl reload
```

## Layout
- `.config/hypr/*.lua` — Hyprland (theme/monitors/input/appearance/bindings/autostart)
- `.config/{waybar,rofi,swaync,alacritty,tmux,gtk-3.0,matugen,nvim}/`
- `.local/bin/` — `arch-menu package-install package-remove power-menu theme-from-wallpaper`
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

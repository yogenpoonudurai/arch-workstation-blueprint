#!/usr/bin/env bash
# install.sh — idempotent dotfiles installer (symlinks, timestamped backups)
set -euo pipefail
DOT="${DOTFILES:-$HOME/dotfiles}"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then return 0; fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local ts; ts=$(date +%Y%m%d-%H%M%S)
    mv -- "$dst" "$dst.bak-$ts"
    echo "backup: $dst -> $dst.bak-$ts"
  fi
  ln -s "$src" "$dst"
  echo "link: $dst -> $src"
}

# Configs. Noctalia is the only desktop shell.
for d in hypr noctalia quickshell alacritty tmux herdr gtk-3.0 gtk-4.0 matugen nvim theme; do
  [ -d "$DOT/.config/$d" ] || continue
  # symlink individual files to avoid clobbering runtime dirs
  for f in $(cd "$DOT/.config/$d" && find . -type f \
    ! -name '*.bak-*' \
    ! -name '*.security-backup' \
    ! -name '*.security-backup-*' | sort); do
    rel="${f#./}"
    link "$DOT/.config/$d/$rel" "$HOME/.config/$d/$rel"
  done
done

mkdir -p "$HOME/.local"
[ -d "$DOT/.local/bin" ] && for f in "$DOT"/.local/bin/*; do
  link "$f" "$HOME/.local/bin/$(basename "$f")"
done

for f in .zprofile .zshrc .tmux.conf; do
  [ -f "$DOT/$f" ] && link "$DOT/$f" "$HOME/$f"
done

# top-level single files in .config
[ -f "$DOT/.config/starship.toml" ] && link "$DOT/.config/starship.toml" "$HOME/.config/starship.toml"

echo "done. Reload: hyprctl reload; tmux source ~/.config/tmux/tmux.conf"

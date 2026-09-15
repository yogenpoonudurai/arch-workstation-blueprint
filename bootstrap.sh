#!/usr/bin/env bash
# bootstrap.sh — fresh Arch PC provisioner. Idempotent, re-runnable.
# Usage (on new PC after archinstall):
#   git clone <your-dotfiles-remote> ~/dotfiles && ~/dotfiles/bootstrap.sh
#   # or: DOTFILES_REPO=<url> curl -sL <this-file-url> | bash
set -euo pipefail

DOT="${DOTFILES:-$HOME/dotfiles}"
PKG="$DOT/packages"

die() { echo "ERR: $*" >&2; exit 1; }
[ -f /etc/arch-release ] || die "Arch Linux required"
command -v sudo >/dev/null || die "sudo required"

# Optional: clone dotfiles if running via pipe and repo given
if [ ! -d "$DOT" ]; then
  [ -n "${DOTFILES_REPO:-}" ] || die "no ~/dotfiles; set DOTFILES_REPO=<url> or clone manually"
  git clone "$DOTFILES_REPO" "$DOT"
fi

echo "==> sudo keep-alive"
sudo -v

echo "==> AUR helper (paru-bin, prebuilt — no rust compile)"
if ! command -v paru >/dev/null 2>&1; then
  tmp="$(mktemp -d)"
  git clone --depth=1 https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
  (cd "$tmp/paru-bin" && makepkg -si --noconfirm --needed)
  rm -rf "$tmp"
fi

echo "==> repo packages ($(grep -cE '^[^#[:space:]]' "$PKG/pacman.txt") entries)"
grep -vE '^\s*(#|$)' "$PKG/pacman.txt" | sudo pacman -S --needed --noconfirm -

echo "==> AUR packages ($(grep -vE '^\s*(#|$)' "$PKG/aur.txt" | wc -l) entries)"
if [ -s "$PKG/aur.txt" ]; then
  grep -vE '^\s*(#|$)' "$PKG/aur.txt" | paru -S --needed --noconfirm -
fi

echo "==> dotfiles symlinks"
"$DOT/install.sh"

echo "==> Rust toolchain"
rustup default stable 2>/dev/null || true
rustup component add rust-analyzer 2>/dev/null || true

echo "==> Go tools"
while read -r mod; do
  [[ "$mod" =~ ^\s*(#|$) ]] && continue
  go install "$mod"
done < "$PKG/go.txt"

echo "==> pnpm globals"
export PATH="$HOME/.local/share/pnpm/bin:$PATH"
while read -r p; do
  [[ "$p" =~ ^\s*(#|$) ]] && continue
  pnpm add -g "$p"
done < "$PKG/pnpm.txt"

echo "==> cargo tools"
while read -r c; do
  [[ "$c" =~ ^\s*(#|$) ]] && continue
  cargo install "$c"
done < "$PKG/cargo.txt"

echo "==> OMZ (if missing)"
[ -d "$HOME/.oh-my-zsh" ] || git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

echo "==> services (no auth tokens baked in)"
sudo systemctl enable --now NetworkManager bluetooth 2>/dev/null || true
sudo systemctl enable --now tailscaled 2>/dev/null || echo "tailscaled installed but not started — run: sudo tailscale up"

echo
echo "MANUAL (need your password/session, not scripted):"
echo "  1. sudo sh -c 'grep -qxF /usr/bin/zsh /etc/shells || echo /usr/bin/zsh >> /etc/shells'; chsh -s /usr/bin/zsh"
echo "  2. keyring PAM: add pam_gnome_keyring auth+session lines to /etc/pam.d/login"
echo "  3. sudo tailscale up   (interactive auth, never in scripts)"
echo "  4. reboot; SUPER+Enter → zsh; noctalia bar should appear"

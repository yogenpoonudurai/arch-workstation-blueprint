# Arch Workstation Blueprint

An opinionated Arch Linux workstation built around Hyprland, Noctalia,
`linux-hardened`, AppArmor, UFW, recovery paths, and reproducible dotfiles.

<img width="1920" height="1080" alt="screenshot_20260915_223855" src="https://github.com/user-attachments/assets/9d325d69-7edd-4202-9938-f84acc810652" />


> [!WARNING]
> This is my working configuration, not a distribution or universal installer.
> It is tested on an AMD ASUS Zenbook 14. Review every privileged script and
> adapt the monitor, storage, package, and hardware settings before running it.

## What this project optimizes for

- Keyboard-first development workflow.
- Noctalia as the single desktop shell; minimal bar and no dock.
- Modular Lua-only Hyprland configuration.
- Defense in depth without removing recovery paths.
- `linux-hardened` as primary, standard `linux` as fallback.
- Explicit verification instead of undocumented security claims.
- No passwords, tokens, private keys, or destructive partitioning in Git.

## Verified security status

Last locally verified on 2026-09-16:

| Control | Status |
| --- | --- |
| `linux-hardened` running | Verified |
| Standard UKI file present | Verified; bootability requires a local test |
| AppArmor LSM and service | Verified |
| UFW active, deny incoming | Verified |
| GCR SSH agent socket | Verified |
| Hyprland permission enforcement | Verified |
| Exact screencopy grants | Verified |
| Restic backup/restore workflow | Verified |
| Root backed by LUKS2 | **Pending reinstall** |
| Development volume backed by LUKS2 | **Pending reinstall** |
| Secure Boot | Deferred |

`linux-hardened` is one layer. It does not replace disk encryption, updates,
least privilege, backups, application isolation, or careful package review.

## Tested system

- AMD ASUS Zenbook 14 UM3406HA.
- Arch Linux with systemd-boot and UKIs.
- Hyprland 0.56.x through UWSM.
- Internal `eDP-1` plus optional `DP-2` and `HDMI-A-1` displays.
- Separate `/mnt/Development` filesystem.

Different hardware will require changes. At minimum, inspect:

- `.config/hypr/config/monitors.lua`
- `packages/pacman.txt`
- `DEVELOPMENT_PATH`
- display scaling, brightness, audio firmware, and power management

## Repository layout

- `.config/hypr/` — modular Lua Hyprland configuration.
- `.config/noctalia/` — bar, launcher, notifications, control center, OSD,
  wallpaper, lock screen, and private clipboard behavior.
- `.config/{alacritty,nvim,tmux,herdr,gtk-3.0,gtk-4.0,matugen,theme}/`
- `.local/bin/` — screenshots, monitor control, package UI, and theme tools.
- `packages/` — repository, AUR, Cargo, Go, and pnpm manifests.
- `install/` — post-install security, hardened UKI, and verification scripts.
- `scripts/backup-restic` — fail-closed external backup helper.
- `bootstrap.sh` — Arch-only workstation provisioning.
- `install.sh` — idempotent dotfile symlink installer.

## Before installing

1. Read `bootstrap.sh`, `install.sh`, and every file under `install/`.
2. Edit `.config/hypr/config/monitors.lua` for `hyprctl monitors all` output.
3. Review every package manifest.
4. Back up and test restoring important data.
5. Keep a bootable Arch ISO and the standard kernel fallback.

The bootstrap installs trusted repository packages non-interactively. It does
not install AUR packages. Audit each complete PKGBUILD checkout—including
sources, patches, and install hooks—before manually installing entries from
`packages/aur.txt`.

## Install on an existing Arch system

```bash
git clone https://github.com/yogenpoonudurai/arch-workstation-blueprint.git ~/dotfiles
cd ~/dotfiles
less bootstrap.sh install.sh install/*.sh
./install.sh
hyprctl reload
```

`install.sh` creates timestamped backups before replacing existing files with
symlinks. It does not install packages or modify system configuration.

## Fresh workstation

Start from a working Arch installation, then:

```bash
git clone https://github.com/yogenpoonudurai/arch-workstation-blueprint.git ~/dotfiles
cd ~/dotfiles
less bootstrap.sh install.sh install/*.sh
./bootstrap.sh
```

The bootstrap:

1. Installs official repository packages and CPU-appropriate microcode.
2. Prints AUR entries for manual review; it never installs them.
3. Links the dotfiles.
4. Installs pinned Go tools plus Cargo tools; pnpm globals remain manual.
5. Enables workstation services.
6. Runs the interactive security post-install script.

It deliberately leaves pnpm package review, Tailscale authentication, and
hardened-kernel promotion manual.

## Encryption layout

Disk partitioning and encryption are installation-time operations and are never
automated here. The intended layout is:

```text
4 GB    EFI (FAT32, /boot)
320 GB  LUKS2 → Btrfs (@, @home, @log, @snapshots)
rest    LUKS2 → ext4 (/mnt/Development)
```

The currently published machine has not completed this migration. Do not treat
the layout above as evidence that encryption is already active.

## Security baseline

Run locally—not through SSH or Mosh:

```bash
install/security-postinstall.sh
```

It requires explicit firewall confirmation, backs up `/etc/pam.d/login` before
changes, configures GNOME Keyring PAM integration, enables AppArmor and fstrim,
sets UFW to deny incoming traffic, starts the GCR SSH agent socket, and ensures
Hyprland exclusively owns `hypridle`.

UFW does not implicitly trust Tailnet peers. Add only the exact inbound rules
your workflow needs; for example, SSH over Tailscale:

```bash
sudo ufw allow in on tailscale0 to any port 22 proto tcp
```

Prefer narrower source-address rules and Tailscale grants where practical.

## Hardened kernel and recovery

Both `linux` and `linux-hardened` are required. Generate the hardened UKI:

```bash
install/security-hardened-uki.sh
```

The script refuses to proceed unless the standard UKI exists. It creates an
AppArmor-enabled hardened command line and leaves the standard UKI untouched.
File presence does not prove that the fallback boots: verify it explicitly.

Boot-test the standard image and validate storage access first:

```bash
sudo bootctl set-oneshot arch-linux.efi
systemctl reboot
```

After the standard image succeeds, test the hardened image once:

```bash
sudo bootctl set-default arch-linux.efi
sudo bootctl set-oneshot arch-linux-hardened.efi
systemctl reboot
```

Validate Wi-Fi, audio, Bluetooth, brightness, lock, Tailscale, and
suspend/resume. Only then:

```bash
sudo bootctl set-default arch-linux-hardened.efi
```

## Verification

```bash
sudo -v
install/security-verify.sh
```

For a different Development mount:

```bash
DEVELOPMENT_PATH=/path/to/development install/security-verify.sh
```

The verifier exits nonzero if a required control fails. It uses cached sudo
authorization to inspect the live UFW state without prompting. A red result is
a finding to fix, not output to hide.

## Backup and recovery

The backup helper requires the Development path and Restic repository to be
mounted on filesystems different from every source being backed up:

```bash
scripts/backup-restic "/run/media/$USER/Backup Drive/Backup/restic-arch"
```

It backs up `$HOME`, the Development volume, `/etc`, and `/boot`, excluding
caches, trash, and `.terraform` provider caches. Terraform state and variable
files are retained intentionally because they may be critical recovery data.

Verification remains a separate, deliberate step:

```bash
sudo restic -r /path/to/repository check --read-data
```

Never commit Restic passwords, LUKS passphrases, Tailscale tokens, SSH private
keys, or Secure Boot keys.

## Desktop notes

- `Super+Enter` — Alacritty.
- `Super+Alt+Enter` — persistent tmux session.
- `Super+Space` — Noctalia launcher.
- `Super+C` — control center.
- `Super+Shift+C` — clipboard history.
- `Print` / `Super+Print` — full/region screenshots.
- tmux `Ctrl+B /` — search pane scrollback.
- shell `Ctrl+R` — fuzzy command-history search.

Theme helpers:

```bash
theme-set oled-default|tokyo-night|catppuccin
theme-from-wallpaper ~/Pictures/Wallpapers/your.jpg
```

## Performance checks

```bash
time zsh -i -c exit
nvim --startuptime /tmp/nvim-start.log +qa
tail -5 /tmp/nvim-start.log
```

## Contributing

Hardware profiles, portability fixes, documentation, recovery improvements,
and evidence-backed security changes are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md)
before opening a pull request. Report security vulnerabilities according to
[SECURITY.md](SECURITY.md), not in a public issue.

## Roadmap

- Complete and verify LUKS2 migration for root and Development.
- Evaluate Secure Boot after the encrypted installation is stable.
- Separate additional hardware profiles from the tested Zenbook defaults.
- Add automated static validation without automating destructive operations.

## Credits and license

Built on Arch Linux, Hyprland, Noctalia, and their ecosystems. Some configuration
ideas were inspired by Omarchy; the Neovim setup derives from LazyVim. See
[THIRD_PARTY.md](THIRD_PARTY.md) for attribution.

Original repository content is available under the [MIT License](LICENSE).

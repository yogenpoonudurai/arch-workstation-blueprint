-- environment.lua — Wayland session env, OLED-safe cursor.
-- Requires Hyprland restart for some vars (not just reload).

hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")

-- Permissions (require Hyprland restart, not reload)
hl.config({
  ecosystem = {
    enforce_permissions = false,
  },
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")

-- GNOME Keyring / SSH agent integration (works with uwsm + PAM)
hl.env("SSH_AUTH_SOCK", "/run/user/1000/gcr/ssh")

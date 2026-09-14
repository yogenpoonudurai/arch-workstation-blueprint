-- autostart.lua — UWSM-aware autostart, Hyprland 0.56.2
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")

-- Permissions (require Hyprland restart, not reload)
hl.config({
  ecosystem = {
    enforce_permissions = false,
  },
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")

hl.on("hyprland.start", function()
  -- Use uwsm app so apps are tracked in systemd scopes.
  hl.exec_cmd("uwsm app -- waybar")
  hl.exec_cmd("uwsm app -- swaync")
  hl.exec_cmd("uwsm app -- swayosd-server")
  -- hyprpaper only if wallpaper exists (avoid failed service spam)
  hl.exec_cmd("[ -f ~/Pictures/Wallpapers/current.jpg ] && uwsm app -- hyprpaper || true")
  hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
  hl.exec_cmd("uwsm app -- hypridle")
  -- hyprlauncher daemon for instant unified-launcher opening
  hl.exec_cmd("uwsm app -- hyprlauncher -d")
end)

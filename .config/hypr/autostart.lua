-- autostart.lua — UWSM-aware autostart, Hyprland 0.56.2
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  -- Use uwsm app so apps are tracked in systemd scopes.
  hl.exec_cmd("uwsm app -- waybar")
  hl.exec_cmd("uwsm app -- swaync")
  hl.exec_cmd("uwsm app -- swayosd-server")
  -- hyprpaper only if wallpaper exists (avoid failed service spam)
  hl.exec_cmd("[ -f ~/Pictures/Wallpapers/current.jpg ] && uwsm app -- hyprpaper || true")
  hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
  hl.exec_cmd("uwsm app -- hypridle")
end)

-- autostart.lua — UWSM-aware autostart, Hyprland 0.56.2
-- Single-shell: Noctalia owns bar/dock/launcher/notifications/control-center/OSD/wallpaper.
-- Legacy waybar/swaync/rofi/swayosd/hyprlauncher/mako removed (packages uninstalled).

hl.on("hyprland.start", function()
  -- Primary shell
  hl.exec_cmd("pidof noctalia >/dev/null || uwsm app -- noctalia")
  -- Hyprland owns these session-scoped processes; do not also enable hypridle.service.
  hl.exec_cmd("pidof hyprpolkitagent >/dev/null || /usr/lib/hyprpolkitagent/hyprpolkitagent")
  hl.exec_cmd("pidof hypridle >/dev/null || uwsm app -- hypridle")
end)

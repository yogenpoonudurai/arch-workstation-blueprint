-- autostart.lua — UWSM-aware autostart, Hyprland 0.56.2
-- Single-shell goal: Noctalia (quickshell) replaces waybar+swaync+swayosd.
-- Keep legacy stack until Noctalia validated, then remove.

-- autostart.lua — UWSM-aware autostart, Hyprland 0.56.2
-- Single-shell: Noctalia owns bar/dock/launcher/notifications/control-center/OSD/wallpaper.
-- Legacy waybar/swaync/rofi/swayosd/hyprlauncher/mako removed (packages uninstalled).

hl.on("hyprland.start", function()
  -- Primary shell
  hl.exec_cmd("pidof noctalia >/dev/null || uwsm app -- noctalia")
  -- Privilege + idle (Noctalia polkit_agent=false, idle behaviors disabled → use these)
  hl.exec_cmd("pidof hyprpolkitagent >/dev/null || /usr/lib/hyprpolkitagent/hyprpolkitagent")
  hl.exec_cmd("pidof hypridle >/dev/null || uwsm app -- hypridle")
end)

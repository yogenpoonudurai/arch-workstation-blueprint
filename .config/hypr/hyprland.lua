-- hyprland.lua — main entry, Lua only, keeps small.
-- Modular imports. Validated for Hyprland 0.56.2.
require("config.theme")
require("config.monitors")
require("config.input")
require("config.environment")
require("config.appearance")
require("config.animations")
require("config.bindings")
require("config.rules")
require("config.autostart")

-- For Noctalia Color templates
require("noctalia").apply_theme()

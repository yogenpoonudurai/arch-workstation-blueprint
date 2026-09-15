-- theme.lua — shared palette + optional Matugen-generated overrides
-- Generated file (if present): ~/.config/theme/colors-hypr.lua
-- It should set globals or return a table; we load it safely and fall back.

local function load_generated()
  local home = os.getenv("HOME") or "/home/yp"
  local path = home .. "/.config/theme/colors-hypr.lua"
  local f = io.open(path, "r")
  if not f then return nil end
  f:close()
  local ok, mod = pcall(dofile, path)
  if ok and type(mod) == "table" then return mod end
  return nil
end

Theme = load_generated() or {}

-- Fallback OLED-friendly dark palette (used until Matugen runs)
Theme.bg         = Theme.bg         or "rgba(0e0e11ff)"
Theme.dark_bg    = Theme.dark_bg    or "rgba(0a0a0eff)"
Theme.surface    = Theme.surface    or "rgba(16161aff)"
Theme.surface2   = Theme.surface2   or "rgba(1e1e24ff)"
Theme.lighter_bg = Theme.lighter_bg or "rgba(232329ff)"
Theme.selection  = Theme.selection  or "rgba(2e2e3aff)"
Theme.border     = Theme.border     or "rgba(2e2e36ff)"
Theme.active1    = Theme.active1    or "rgba(7aa2f7ee)"
Theme.active2    = Theme.active2    or "rgba(bb9af7ee)"
Theme.inactive   = Theme.inactive   or "rgba(595959aa)"
Theme.fg         = Theme.fg         or "rgba(e6e6ebff)"
Theme.dark_fg    = Theme.dark_fg    or "rgba(9a9aa3ff)"
Theme.muted      = Theme.muted      or "rgba(6b6b76ff)"
Theme.yellow     = Theme.yellow     or "rgba(e5c07bff)"
Theme.red        = Theme.red        or "rgba(e06c75ff)"
Theme.green      = Theme.green      or "rgba(98c379ff)"

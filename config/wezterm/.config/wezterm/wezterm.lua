local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- CONFIG
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14
config.enable_tab_bar = false
config.initial_cols = 120
config.initial_rows = 30
config.audible_bell = "Disabled"

return config

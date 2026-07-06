local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- config.color_scheme = "Gruvbox Dark (Gogh)"
-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "tokyonight" -- favorite

config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 16

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.initial_rows = 100
config.initial_cols = 600

config.background = {
	{
		source = { File = wezterm.config_dir .. "/assets/firewatch.jpg" },
		horizontal_align = "Center",
		vertical_align = "Middle",
	},

	{
		source = {
			Color = "#1a1b26", -- Tokyo Night background
		},
		width = "100%",
		height = "100%",
		opacity = 0.83,
	},
}

return config

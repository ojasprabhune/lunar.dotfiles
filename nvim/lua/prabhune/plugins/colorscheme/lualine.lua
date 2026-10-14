return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			-- theme = "gruvbox", -- set theme to gruvbox
			theme = "tokyonight", -- set theme to tokyonight
			-- theme = "catppuccin-mocha", -- set theme to catppuccin-mocha
			component_separators = "",
			section_separators = "",
			globalstatus = false,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { { "filetype", icons_enabled = false, fmt = string.upper } },
			lualine_c = { { "filename", path = 1 } }, -- show relative path
			lualine_x = {
				"filesize",
				{ "filename", file_status = false, symbols = { unnamed = "" } },
				{
					"diff",
					symbols = { added = "⊞ ", modified = "▣ ", removed = "⊟ " },
				},
			},
			lualine_y = {
				"location",
				"progress",
				function()
					return tostring(vim.api.nvim_buf_line_count(0))
				end,
			},
			lualine_z = { "encoding", "branch" },
		},
	},
}

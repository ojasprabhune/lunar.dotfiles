-- show a plain label for nvim-tree instead of its buffer name
local nvim_tree = {
	filetypes = { "NvimTree" },
	sections = { lualine_a = {
		function()
			return "nvim-tree"
		end,
	} },
	inactive_sections = { lualine_c = {
		function()
			return "nvim-tree"
		end,
	} },
}

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
			lualine_x = { "filetype" }, -- default minus encoding and fileformat
		},
		extensions = { nvim_tree },
	},
}

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	-- enabled = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		filters = {
			dotfiles = false,
		},
		view = {
			width = {
				min = 30,
				max = 50,
				padding = 1,
			},
		},
	},
}

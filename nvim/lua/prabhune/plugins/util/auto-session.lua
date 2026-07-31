return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

		bypass_save_filetypes = {
			"NvimTree",
			"neo-tree",
			"dashboard",
			"alpha",
		},
		-- log_level = 'debug',

		auto_save_enabled = true,
		auto_restore_enabled = true,

		log_level = "error",
		auto_session_enable_last_session = false,
		auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
		auto_session_enabled = true,

		-- this forces Neovim to update its working directory
		auto_session_create_enabled = true,

		-- Tell auto-session never to save nvim-tree state
		session_lens = {
			load_on_setup = true,
		},

		-- prevent nvim-tree from being captured in the session file
		pre_save_cmds = { "NvimTreeClose" },
		post_restore_cmds = { "NvimTreeOpen" },
	},
}

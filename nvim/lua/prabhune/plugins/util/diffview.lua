return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Repo commit history" },
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
	},
	opts = {
		enhanced_diff_hl = true, -- cleaner add/delete colors in the diff panes
		file_panel = {
			listing_style = "list", -- flat list instead of a folder tree
			win_config = { width = 35 },
		},
	},
}

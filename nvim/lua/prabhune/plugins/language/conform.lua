return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			-- use ruff for fixing and formatting, or fallback to black
			python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
			-- use prettier for common web/config formats
			lua = { "stylua" },
			javascript = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
		-- autocmd logic, format on save
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback", -- use LSP if no formatter is found
		},
	},
}

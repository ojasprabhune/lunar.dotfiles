local comment_wrap = require("prabhune.config.comment_wrap")

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	init = function()
		-- match textwidth to the formatter's line length so comments also wrap while typing
		vim.api.nvim_create_autocmd("FileType", {
			pattern = comment_wrap.filetypes,
			callback = function(args)
				vim.bo[args.buf].textwidth = comment_wrap.line_length(args.buf)
				vim.opt_local.formatoptions:remove("t") -- leave code wrapping to the formatter
				vim.opt_local.formatoptions:append("cq") -- auto-wrap comments, allow gq
			end,
		})
	end,
	opts = {
		formatters_by_ft = {
			-- use ruff for fixing and formatting, or fallback to black
			python = { "ruff_fix", "ruff_organize_imports", "ruff_format", "wrap_comments" },
			-- use prettier for common web/config formats
			lua = { "stylua", "wrap_comments" },
			javascript = { "prettier", "wrap_comments" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
		formatters = {
			-- split comments that run past the line length (formatters skip comments)
			wrap_comments = {
				format = function(_, ctx, lines, callback)
					callback(nil, comment_wrap.wrap(ctx.buf, lines))
				end,
			},
		},
		-- autocmd logic, format on save
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback", -- use LSP if no formatter is found
		},
	},
}

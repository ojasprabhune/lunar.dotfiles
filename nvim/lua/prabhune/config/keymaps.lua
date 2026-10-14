-- ============================================================================
-- editing
-- ============================================================================

-- select lines with "v", then "J" or "K" to move them down or up
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- <leader>s: replace every instance of the word under the cursor
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search and replace", silent = true }
)

-- search and replace within the current line only
vim.keymap.set("n", "<leader>fl", function()
	local str1 = vim.fn.input("Find: ")
	if str1 == "" then
		return
	end
	local str2 = vim.fn.input("Replace with: ")
	vim.cmd("s/" .. str1 .. "/" .. str2 .. "/g")
	vim.cmd("noh") -- clear search highlight
end, { desc = "Search and replace in current line", silent = true })

-- ============================================================================
-- navigation & UI
-- ============================================================================

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Project view" }) -- netrw file explorer
vim.keymap.set("n", "<leader>ee", vim.cmd.NvimTreeToggle, { desc = "File explorer" })
vim.keymap.set("n", "<C-j>", "<C-w>w", { desc = "Navigation" }) -- cycle between panes
vim.keymap.set("n", "<leader>tt", vim.cmd.FloatermNew, { desc = "Open terminal" })
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview", silent = true })
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")

-- ============================================================================
-- plugin managers
-- ============================================================================

vim.keymap.set("n", "<leader>l", vim.cmd.Lazy, { desc = "Lazy" }) -- lazy.nvim plugin manager
vim.keymap.set("n", "<leader>M", vim.cmd.Mason, { desc = "Mason" }) -- mason.nvim LSP/tool installer

-- ============================================================================
-- LSP
-- ============================================================================

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({
		border = "rounded", -- options: "single", "double", "rounded", "solid", "shadow"
	})
end, { desc = "Documentation" })

vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	---@diagnostic disable-next-line: missing-parameter
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = "Code action" })

-- ============================================================================
-- copilot
-- ============================================================================

-- accept the current suggestion
vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
})

vim.keymap.set("n", "<leader>ec", "<cmd>Copilot enable<CR>", { desc = "Enable Copilot", silent = true })
vim.keymap.set("n", "<leader>dc", "<cmd>Copilot disable<CR>", { desc = "Disable Copilot", silent = true })

-- ============================================================================
-- git
-- ============================================================================

vim.keymap.set("n", "<leader>dt", "<cmd>Gitsigns diffthis HEAD<CR>", { desc = "Git diff" })

-- close the gitsigns:// split and turn off diff mode in all windows
local function close_gitsigns_diff()
	vim.cmd("diffoff!")
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_get_name(buf):match("^gitsigns://") then
			vim.api.nvim_win_close(win, true)
		end
	end
end

-- ============================================================================
-- buffers & sessions
-- ============================================================================

vim.keymap.set("n", "<leader>kk", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>jj", "<cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>cc", "<cmd>AutoSession delete<CR>", { desc = "Delete session" })

vim.keymap.set("n", "<leader>dd", function()
	-- in a diff: only close the diff window and leave the buffer list alone
	if vim.wo.diff then
		close_gitsigns_diff()
		return
	end

	-- listed buffers that are real files (excludes special buftypes like terminals)
	local real_bufs = vim.tbl_filter(function(buf)
		return buf.listed == 1 and vim.bo[buf.bufnr].buftype == ""
	end, vim.fn.getbufinfo({ buflisted = 1 }))

	local current_buf = vim.api.nvim_get_current_buf()

	if #real_bufs > 1 then
		-- more than one file buffer: switch to previous, then delete the old one
		vim.cmd("bprevious")
		vim.cmd("bdelete " .. current_buf)
	else
		-- last file buffer: open NvimTree, then delete the remaining buffer
		require("nvim-tree.api").tree.open()
		vim.cmd("bdelete " .. current_buf)
	end
end, { desc = "Delete buffer" })

-- click "v", then "J" or "K" to move line up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move line down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move line up

-- general commands
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Project view" }) -- open file explorer
vim.keymap.set("n", "<leader>ee", vim.cmd.NvimTreeToggle, { desc = "File explorer" }) -- toggle file explorer
vim.keymap.set("n", "<C-j>", "<C-w>w", { desc = "Navigation" }) -- navigation between neovim panes
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy, { desc = "Lazy" }) -- lazy.nvim plugin manager
vim.keymap.set("n", "<leader>m", vim.cmd.Mason, { desc = "Mason" }) -- mason.nvim lsp package manager
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>") -- make it rain
vim.keymap.set("n", "<leader>tt", vim.cmd.FloatermNew, { desc = "Open terminal" }) -- open terminal
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" }) -- definition
vim.keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "Rename symbol" }) -- rename

-- click spacebar then "s" to change all instances of the word the cursor is above
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search and replace", silent = true }
)

-- code actions
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	---@diagnostic disable-next-line: missing-parameter
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = "Code action" })

-- copilot accept keybind
vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
})

-- search and replace in line
vim.keymap.set("n", "<leader>fl", function()
	-- prompt for search term
	local str1 = vim.fn.input("Find: ")
	if str1 == "" then
		return
	end
	-- prompt for replacement term
	local str2 = vim.fn.input("Replace with: ")
	-- run substitution on the current line
	vim.cmd("s/" .. str1 .. "/" .. str2 .. "/g")
	-- clear search highlight
	vim.cmd("noh")
end, { desc = "Search and replace in current line", silent = true })

-- enable Copilot
vim.keymap.set("n", "<leader>ec", "<cmd>Copilot enable<CR>", { desc = "Enable Copilot", silent = true })
-- disable Copilot
vim.keymap.set("n", "<leader>dc", "<cmd>Copilot disable<CR>", { desc = "Disable Copilot", silent = true })

-- markdown preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview", silent = true })

-- handle buffers
vim.keymap.set("n", "<leader>cc", "<cmd>AutoSession delete<CR>", { desc = "Delete session" }) -- clear session buffers
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" }) -- quit all buffers
vim.keymap.set("n", "<leader>kk", "<cmd>bnext<CR>", { desc = "Next buffer" }) -- next buffer
vim.keymap.set("n", "<leader>jj", "<cmd>bprev<CR>", { desc = "Previous buffer" }) -- previous buffer
vim.keymap.set("n", "<leader>dd", function()
	-- get all listed buffers that are actual files (exclude unlisted or special buftypes)
	local real_bufs = vim.tbl_filter(function(buf)
		return buf.listed == 1 and vim.bo[buf.bufnr].buftype == ""
	end, vim.fn.getbufinfo({ buflisted = 1 }))

	local current_buf = vim.api.nvim_get_current_buf()

	if #real_bufs > 1 then
		-- more than 1 file buffer: switch to previous, then wipe the target buffer
		vim.cmd("bprevious")
		vim.cmd("bdelete! " .. current_buf)
	else
		-- last file buffer: focus or open NvimTree, then delete the remaining buffer
		require("nvim-tree.api").tree.open()
		vim.cmd("bdelete! " .. current_buf)
	end
end, { desc = "Delete buffer" }) -- delete buffer

vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({
		border = "rounded", -- options: "single", "double", "rounded", "solid", "shadow"
	})
end, { desc = "Documentation" })

-- click "v", then "J" or "K" to move line up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move line down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move line up

-- general commands
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Project view" })              -- open file explorer
vim.keymap.set("n", "<leader>ee", vim.cmd.NvimTreeToggle, { desc = "File explorer" }) -- toggle file explorer
vim.keymap.set("n", "<C-j>", "<C-w>w", { desc = "Editor and explorer navigation" })   -- switch between editor and file explorer
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy, { desc = "Lazy" })                     -- lazy.nvim plugin manager
vim.keymap.set("n", "<leader>m", vim.cmd.Mason, { desc = "Mason" })                   -- mason.nvim lsp package manager
vim.keymap.set("n", "<leader>jj", "<cmd>bnext<CR>", { desc = "Next buffer" })         -- next buffer
vim.keymap.set("n", "<leader>kk", "<cmd>bprev<CR>", { desc = "Previous buffer" })     -- previous buffer
vim.keymap.set("n", "<leader>dd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })     -- delete current buffer
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")         -- make it rain
vim.keymap.set("n", "<leader>tt", vim.cmd.FloatermNew, { desc = "Open terminal" })    -- open terminal

-- click spacebar then "s" to change all instances of the word the cursor is above
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace", silent = true })

-- code actions
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
  ---@diagnostic disable-next-line: missing-parameter
  require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = "Code action" })

-- copilot accept keybind
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})

-- search and replace in line
vim.keymap.set("n", "<leader>fl", function()
  -- Prompt for search term
  local str1 = vim.fn.input("Find: ")
  if str1 == "" then return end
  -- Prompt for replacement term
  local str2 = vim.fn.input("Replace with: ")
  -- Run substitution on the current line
  vim.cmd("s/" .. str1 .. "/" .. str2 .. "/g")
  -- Clear search highlight
  vim.cmd("noh")
end, { desc = "Search and replace in current line", silent = true })

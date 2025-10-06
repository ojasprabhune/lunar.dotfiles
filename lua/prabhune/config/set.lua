-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.tabstop = 2                                            -- number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 2                                        -- number of spaces a <Tab> counts for while performing editing operations
vim.opt.shiftwidth = 2                                         -- number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true                                       -- use spaces instead of tabs
vim.opt.autoindent = true                                      -- copy indent from current line when starting a new line
vim.opt.smartindent = true                                     -- add extra indent after {, (, [
vim.opt.smarttab = true                                        -- insert tabs on the start of a line according to shiftwidth

vim.opt.number = true                                          -- show line numbers
vim.opt.cursorline = true                                      -- highlight current line
vim.opt.signcolumn = "yes:1"                                   -- always show signcolumn
vim.opt.scrolloff = 8                                          -- minimum lines to keep above and below cursor
vim.opt.showcmd = true                                         -- show (partial) command in status line

vim.opt.swapfile = false                                       -- disable swapfile
vim.opt.backup = false                                         -- disable backup
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir" -- set undo directory
vim.opt.undofile = true                                        -- persistent undo
vim.opt.clipboard = "unnamed"                                  -- use system clipboard

vim.opt.hlsearch = true                                        -- highlight all matches on previous search pattern
vim.opt.incsearch = true                                       -- show where the pattern, as it was typed, matches
vim.opt.ignorecase = true                                      -- ignore case in search patterns
vim.opt.smartcase = true                                       -- override ignorecase if search contains uppercase letters
vim.opt.showmode = false                                       -- don't show mode since we use a statusline
vim.diagnostic.config { virtual_text = true }                  -- disable virtual text for diagnostics

vim.g.copilot_enabled = 0                                      -- disable copilot by default
vim.g.netrw_liststyle = 3                                      -- tree view in netrw

-- colorscheme
vim.o.background = "dark" -- or "light" for light mode
vim.cmd.colorscheme "gruvbox"

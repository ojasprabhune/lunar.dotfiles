return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  module = "telescope",

  config = function()
    require('telescope').setup {}

    local builtin = require('telescope.builtin')

    vim.keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true <CR>", { desc = "File search" })
    vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>", { desc = "File browser" })
    vim.keymap.set("n", "<leader>ft", ":Telescope live_grep hidden=true <CR>", { desc = "Word search" })
    vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git search" })
    vim.keymap.set("n", "<leader>ww", builtin.current_buffer_fuzzy_find, { desc = "Word search in current buffer" })
    vim.keymap.set("n", "<leader>ps", function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Project search" })

    -- search for either a word under cursor or entire phrase under cursor
    vim.keymap.set('n', '<leader>fw', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end, { desc = "Word search (under cursor)" })
    vim.keymap.set('n', '<leader>fW', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, { desc = "Phrase search (under cursor)" })
  end
}

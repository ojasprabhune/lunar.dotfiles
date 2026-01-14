return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    'nvim-tree/nvim-tree.lua',
    'nvim-telescope/telescope',
  },
  picker = {
    provider = "telescope"
  }
}

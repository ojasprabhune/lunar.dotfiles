return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  -- enabled = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    filters = {
      dotfiles = false,
    },
  },
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'gruvbox', -- set theme to gruvbox
      -- theme = 'tokyonight', -- set theme to tokyonight
    },
    sections = {
      lualine_c = { { 'filename', path = 1 } } -- show relative path
    }
  }
}

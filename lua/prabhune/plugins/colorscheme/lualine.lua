return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'gruvbox', -- set theme to gruvbox
    },
    sections = {
      lualine_c = { { 'filename', path = 1 } } -- show relative path
    }
  }
}

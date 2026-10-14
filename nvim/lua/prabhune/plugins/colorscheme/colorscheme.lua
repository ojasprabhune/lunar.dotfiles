-- return {
--   "ellisonleao/gruvbox.nvim",
--   priority = 1000,
--   config = true,
--   opts = {
--     transparent_mode = true,
--   },
-- }

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_highlights = function(hl, c)
      local separator = c.fg_gutter -- #3b4261
      hl.WinSeparator = { fg = separator, bold = true }
      hl.NvimTreeWinSeparator = { fg = separator, bg = c.none }
    end,
  },
}

-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   priority = 1000,
--   opts = {
--     flavour = "mocha",
--     transparent_background = true,
--     auto_integrations = true,
--     float = {
--       transparent = true, -- enable transparent floating windows
--     },
--   },
-- }

-- return {
--   "rebelot/kanagawa.nvim"
-- }
